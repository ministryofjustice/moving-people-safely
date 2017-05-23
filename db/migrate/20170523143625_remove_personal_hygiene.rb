class RemovePersonalHygiene < ActiveRecord::Migration[5.0]
  def change
    remove_column :healthcare, :personal_hygiene
    remove_column :healthcare, :personal_hygiene_details
  end
end
