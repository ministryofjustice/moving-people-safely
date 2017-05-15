class AddCreatedWeaponsToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :uses_weapons, :string
    add_column :risks, :uses_weapons_details, :text
  end
end
