class AddSubstanceSupplyDetailsToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :substance_supply_details, :text
  end
end
