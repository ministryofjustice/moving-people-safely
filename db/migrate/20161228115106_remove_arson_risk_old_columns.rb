class RemoveArsonRiskOldColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :arson_details
    remove_column :risks, :arson_value
    remove_column :risks, :damage_to_property_details
  end
end
