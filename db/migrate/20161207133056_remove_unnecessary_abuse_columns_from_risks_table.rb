class RemoveUnnecessaryAbuseColumnsFromRisksTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :verbal_abuse
    remove_column :risks, :verbal_abuse_details
    remove_column :risks, :physical_abuse
    remove_column :risks, :physical_abuse_details
  end
end
