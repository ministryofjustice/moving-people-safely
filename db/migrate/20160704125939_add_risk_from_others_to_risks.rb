class AddRiskFromOthersToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :rule_45, :string, default: 'unknown'
    add_column :risks, :rule_45_details, :text
    add_column :risks, :csra, :string, default: 'unknown'
    add_column :risks, :csra_details, :text
    add_column :risks, :verbal_abuse, :string, default: 'unknown'
    add_column :risks, :verbal_abuse_details, :text
    add_column :risks, :physical_abuse, :string, default: 'unknown'
    add_column :risks, :physical_abuse_details, :text
  end
end
