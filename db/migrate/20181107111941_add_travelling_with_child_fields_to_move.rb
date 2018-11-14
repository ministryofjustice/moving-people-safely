class AddTravellingWithChildFieldsToMove < ActiveRecord::Migration[5.2]
  def change
    add_column :moves, :travelling_with_child, :string
    add_column :moves, :child_full_name, :string
    add_column :moves, :child_date_of_birth, :date
  end
end
