class RemoveSecurityRiskOldColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :restricted_status
    remove_column :risks, :restricted_status_details
    remove_column :risks, :escape_pack
    remove_column :risks, :escape_risk_assessment
    remove_column :risks, :cuffing_protocol
  end
end
