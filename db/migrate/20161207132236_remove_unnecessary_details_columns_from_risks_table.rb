class RemoveUnnecessaryDetailsColumnsFromRisksTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :rule_45_details
    remove_column :risks, :csra_details
  end
end
