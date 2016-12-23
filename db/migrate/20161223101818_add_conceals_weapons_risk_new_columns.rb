class AddConcealsWeaponsRiskNewColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :conceals_drugs, :string
    add_column :risks, :conceals_drugs_details, :text
    add_column :risks, :conceals_mobile_phone_or_other_items, :text
    add_column :risks, :conceals_mobile_phones, :boolean
    add_column :risks, :conceals_sim_cards, :boolean
    add_column :risks, :conceals_other_items, :boolean
    add_column :risks, :conceals_other_items_details, :text
  end
end
