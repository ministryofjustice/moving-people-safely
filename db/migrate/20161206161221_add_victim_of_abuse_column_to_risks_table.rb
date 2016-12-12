class AddVictimOfAbuseColumnToRisksTable < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :victim_of_abuse, :string
    add_column :risks, :victim_of_abuse_details, :text
  end
end
