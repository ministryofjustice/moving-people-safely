class AddAcctStatusToRisks < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :open_acct
    remove_column :risks, :suicide
    remove_column :risks, :suicide_details
    add_column    :risks, :acct_status, :string
    add_column    :risks, :acct_status_details, :text
    add_column    :risks, :date_of_most_recently_closed_acct, :date
  end
end
