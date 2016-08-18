class EscapeListChanges < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :escape_list
    remove_column :risks, :escape_list_details
    remove_column :risks, :other_escape_risk_info
    remove_column :risks, :other_escape_risk_info_details
  end
end
