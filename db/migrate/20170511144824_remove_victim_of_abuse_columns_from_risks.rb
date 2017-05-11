class RemoveVictimOfAbuseColumnsFromRisks < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :victim_of_abuse, :string
    remove_column :risks, :victim_of_abuse_details, :string
  end
end
