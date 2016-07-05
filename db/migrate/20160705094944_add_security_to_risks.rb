class AddSecurityToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :current_e_risk, :string, default: 'unknown'
    add_column :risks, :current_e_risk_details, :text
    add_column :risks, :escape_list, :string, default: 'unknown'
    add_column :risks, :escape_list_details, :text
    add_column :risks, :other_escape_risk_info, :string, default: 'unknown'
    add_column :risks, :other_escape_risk_info_details, :text
    add_column :risks, :category_a, :string, default: 'unknown'
    add_column :risks, :category_a_details, :text
    add_column :risks, :restricted_status, :string, default: 'unknown'
    add_column :risks, :restricted_status_details, :text
    add_column :risks, :escape_pack, :boolean
    add_column :risks, :escape_risk_assessment, :boolean
    add_column :risks, :cuffing_protocol, :boolean
  end
end
