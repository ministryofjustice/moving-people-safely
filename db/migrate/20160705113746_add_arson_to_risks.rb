class AddArsonToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :arson, :string, default: 'unknown'
    add_column :risks, :arson_details, :text
    add_column :risks, :arson_value, :string
    add_column :risks, :damage_to_property, :string, default: 'unknown'
    add_column :risks, :damage_to_property_details, :text
  end
end
