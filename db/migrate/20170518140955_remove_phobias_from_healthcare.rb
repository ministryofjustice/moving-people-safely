class RemovePhobiasFromHealthcare < ActiveRecord::Migration[5.0]
  def change
    remove_column :healthcare, :phobias, :string
    remove_column :healthcare, :phobias_details, :text
  end
end
