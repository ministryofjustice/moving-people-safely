class AddMedicationsToHealthcare < ActiveRecord::Migration[5.0]
  def change
    add_column :healthcare, :medications, :text
  end
end
