class AddNewSubstanceMisuseColumnsToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :trafficking_drugs, :boolean
    add_column :risks, :trafficking_alcohol, :boolean
    remove_column :risks, :substance_supply_details
  end
end
