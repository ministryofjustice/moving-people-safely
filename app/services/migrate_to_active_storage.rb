# frozen_string_literal: true

# Migrate S3 docs from Paperclip to ActiveStorage
class MigrateToActiveStorage
  DEFAULT_LIMIT = 100

  def initialize
    @s3 = Aws::S3::Resource.new(
      region: YAML.load_file(Rails.root.join('config/storage.yml'))['amazon']['region']
    )
    @s3_bucket = @s3.bucket(ENV['S3_BUCKET_NAME'])
    set_counts(nil, nil)
  end

  def migrate_all(limit = DEFAULT_LIMIT)
    set_counts(0, limit)
    escorts.each do |escort|
      migrate(escort)
      break if @counts[:processed] == @counts[:limit]
    end
    set_counts(nil, nil)
  end

  def migrate(escort)
    return if already_active_storage?(escort)

    paperclip_file = paperclip_file(paperclip_obj(escort), escort.id)
    return if paperclip_file.nil?

    escort.document.attach(
      io: paperclip_file.body,
      filename: escort.document_file_name,
      content_type: 'application/pdf'
    )

    @counts[:processed] += 1 unless @counts[:processed].nil?
    log(:info, 'ActiveStorage file attached and created in S3', escort.id, counts: !@counts[:processed].nil?)
  end

  def purge_paperclip_files(limit = DEFAULT_LIMIT)
    set_counts(0, limit)
    escorts = Escort.with_attached_document.limit(limit)

    escorts.each do |escort|
      delete_paperclip_file(escort)
      break if @counts[:processed] == @counts[:limit]
    end
    set_counts(nil, nil)
  end

  private

  def already_active_storage?(escort)
    return false unless escort.document.attached?

    log(:warn, 'Already has ActiveStorage file in S3', escort.id)
    true
  end

  def delete_paperclip_file(escort)
    obj = paperclip_obj(escort)
    return unless paperclip_file_exists?(obj, escort.id)

    obj.delete
    @counts[:processed] += 1
    log :info, 'Paperclip file deleted in S3', escort.id, counts: true
  end

  def escorts
    Escort.includes(document_attachment: :blob)
          .where('escorts.document_file_name IS NOT NULL')
  end

  def log(level, message, id, counts: false)
    x_of_y = counts ? message_counts : ''
    Rails.logger.send(level, "Escort: #{id}: #{x_of_y}#{message}")
  end

  def message_counts
    "Processed #{@counts[:processed]} of #{@counts[:limit]}: "
  end

  def set_counts(processed, limit)
    @counts = { processed: processed, limit: limit }
  end

  def paperclip_file(obj, id)
    paperclip_file_exists?(obj, id) ? obj.get : nil
  end

  def paperclip_file_exists?(obj, id)
    return true if obj.exists?

    log :warn, 'Cannot find Paperclip file in S3', id
    false
  end

  def paperclip_key(escort)
    "escorts/documents/#{escort.id}/#{escort.document_file_name}"
  end

  def paperclip_obj(escort)
    @s3_bucket.object(paperclip_key(escort))
  end
end
