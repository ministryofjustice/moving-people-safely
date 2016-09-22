class AddImageFilenameToDetainee < ActiveRecord::Migration[5.0]
  def change
    add_column :detainees, :image_filename, :string, default: ''
  end
end
