# frozen_string_literal: true

# Migrate S3 docs from Paperclip to ActiveStorage
class MigrateToActiveStorage
  DEFAULT_LIMIT = 100

  def initialize
    @s3 = Aws::S3::Resource.new(
      region: YAML.load_file(Rails.root.join('config/storage.yml'))['amazon']['region']
    )
    @s3_bucket = @s3.bucket(ENV['S3_BUCKET_NAME'])
  end

  def migrate_all(limit = DEFAULT_LIMIT)
    total = escorts.limit(limit).count

    escorts.limit(limit).each_with_index do |escort, i|
      Rails.logger.info "Migrating file, escort #{i + 1} of #{total}, ID: #{escort.id}:"
      migrate(escort)
    end
  end

  def migrate(escort)
    return if already_active_storage?(escort)

    paperclip_file = paperclip_file(paperclip_obj(escort))
    return if paperclip_file.nil?

    escort.document.attach(
      io: paperclip_file.body,
      filename: escort.document_file_name,
      content_type: 'application/pdf'
    )

    Rails.logger.info 'ActiveStorage file attached and created in S3'
  end

  def purge_paperclip_files(limit = DEFAULT_LIMIT)
    total = escorts.limit(limit).count

    escorts.limit(limit).each_with_index do |escort, i|
      Rails.logger.info "Deleting Paperclip file, escort #{i + 1} of #{total}, ID: #{escort.id}:"
      delete_paperclip_file(escort)
    end
  end

  private

  def already_active_storage?(escort)
    return false unless escort.document.attached?

    Rails.logger.warn 'Already has ActiveStorage file in S3'
    true
  end

  def delete_paperclip_file(escort)
    return if no_active_storage?(escort)

    obj = paperclip_obj(escort)
    return unless paperclip_file_exists?(obj)

    obj.delete
    Rails.logger.info 'Paperclip file deleted in S3'
  end

  def escorts
    Escort.includes(document_attachment: :blob)
          .where('escorts.document_file_name IS NOT NULL')
  end

  def no_active_storage?(escort)
    return false if escort.document.attached?

    Rails.logger.warn 'Does not have ActiveStorage file in S3'
    true
  end

  def paperclip_file(obj)
    paperclip_file_exists?(obj) ? obj.get : nil
  end

  def paperclip_file_exists?(obj)
    return true if obj.exists?

    Rails.logger.warn 'Cannot find Paperclip file in S3'
    false
  end

  def paperclip_key(escort)
    "escorts/documents/#{escort.id}/#{escort.document_file_name}"
  end

  def paperclip_obj(escort)
    @s3_bucket.object(paperclip_key(escort))
  end
end
