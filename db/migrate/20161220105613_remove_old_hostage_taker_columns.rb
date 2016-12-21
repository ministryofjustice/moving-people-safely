class RemoveOldHostageTakerColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :hostage_taker
    remove_column :risks, :hostage_taker_details
    remove_column :risks, :stalker
    remove_column :risks, :stalker_details
  end
end
