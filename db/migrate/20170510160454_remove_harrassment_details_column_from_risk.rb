class RemoveHarrassmentDetailsColumnFromRisk < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :harassment, :string
    remove_column :risks, :harassment_details, :text
    remove_column :risks, :harasser, :boolean
    remove_column :risks, :harasser_details, :text
    remove_column :risks, :stalker_harasser_bully, :string
  end
end
