class SplitObservationLevelDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :risks, :observation_level_details, :text
    add_column :risks, :observation_level2_details, :text
    add_column :risks, :observation_level3_details, :text
    add_column :risks, :observation_level4_details, :text
  end
end
