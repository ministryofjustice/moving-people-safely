class ChangeSexOffence < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :sex_offence_under18_victim_details
    add_column :risks, :date_most_recent_sexual_offence, :date
  end
end
