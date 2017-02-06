class AddImageFieldToDetainees < ActiveRecord::Migration[5.0]
  def change
    # NOTE: ideally we won't store images in the database but until
    # we put in place a cloud storage solution this will have to do
    add_column :detainees, :image, :binary, limit: 2.megabyte
  end
end
