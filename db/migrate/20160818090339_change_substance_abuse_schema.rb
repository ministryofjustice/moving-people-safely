class ChangeSubstanceAbuseSchema < ActiveRecord::Migration[5.0]
  def change
    rename_column :risks, :drugs, :substance_supply
    rename_column :risks, :drugs_details, :substance_supply_details
    rename_column :risks, :alcohol, :substance_use
    rename_column :risks, :alcohol_details, :substance_use_details
  end
end
