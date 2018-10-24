class AddObservationLevelToRisks < ActiveRecord::Migration[5.2]
  def change
    add_column :risks, :observation_level, :string
    add_column :risks, :observation_level_details, :text
  end
end
