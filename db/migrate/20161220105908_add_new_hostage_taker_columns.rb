class AddNewHostageTakerColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :hostage_taker, :string
    add_column :risks, :staff_hostage_taker, :boolean
    add_column :risks, :date_most_recent_staff_hostage_taker_incident, :date
    add_column :risks, :prisoners_hostage_taker, :boolean
    add_column :risks, :date_most_recent_prisoners_hostage_taker_incident, :date
    add_column :risks, :public_hostage_taker, :boolean
    add_column :risks, :date_most_recent_public_hostage_taker_incident, :date
  end
end
