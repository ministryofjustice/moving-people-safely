class AddHarasserToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :stalker_harasser_bully, :string, default: 'unknown'
    add_column :risks, :hostage_taker, :boolean
    add_column :risks, :hostage_taker_details, :text
    add_column :risks, :stalker, :boolean
    add_column :risks, :stalker_details, :text
    add_column :risks, :harasser, :boolean
    add_column :risks, :harasser_details, :text
    add_column :risks, :intimidator, :boolean
    add_column :risks, :intimidator_details, :text
    add_column :risks, :bully, :boolean
    add_column :risks, :bully_details, :text
  end
end
