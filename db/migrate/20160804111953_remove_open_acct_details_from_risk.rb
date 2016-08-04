class RemoveOpenAcctDetailsFromRisk < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :open_acct_details
  end
end
