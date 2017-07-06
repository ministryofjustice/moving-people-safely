class AddAttachmentFileToEscorts < ActiveRecord::Migration[5.0]
  def self.up
    change_table :escorts do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :escorts, :document
  end
end
