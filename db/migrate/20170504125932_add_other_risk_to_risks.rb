class AddOtherRiskToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :other_risk, :string
    add_column :risks, :other_risk_details, :text
  end
end
