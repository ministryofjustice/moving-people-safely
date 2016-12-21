class AddNewHarassmentIntimidatorColumnsToRisksTable < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :harassment, :string
    add_column :risks, :harassment_details, :text
    add_column :risks, :intimidation, :text
    add_column :risks, :intimidation_to_staff, :boolean
    add_column :risks, :intimidation_to_staff_details, :text
    add_column :risks, :intimidation_to_public, :boolean
    add_column :risks, :intimidation_to_public_details, :text
    add_column :risks, :intimidation_to_other_detainees, :boolean
    add_column :risks, :intimidation_to_other_detainees_details, :text
    add_column :risks, :intimidation_to_witnesses, :boolean
    add_column :risks, :intimidation_to_witnesses_details, :text
  end
end
