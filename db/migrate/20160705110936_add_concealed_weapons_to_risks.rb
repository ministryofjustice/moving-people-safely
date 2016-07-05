class AddConcealedWeaponsToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :conceals_weapons, :string, default: 'unknown'
    add_column :risks, :conceals_weapons_details, :text
  end
end
