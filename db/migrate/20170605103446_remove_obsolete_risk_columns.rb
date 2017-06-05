class RemoveObsoleteRiskColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :detainee_id, :uuid
    remove_column :risks, :category_a_details, :text
    remove_column :risks, :bully, :boolean
    remove_column :risks, :bully_details, :text
    remove_column :risks, :intimidator, :boolean
    remove_column :risks, :intimidator_details, :text
    remove_column :risks, :police, :boolean
    remove_column :risks, :police_details, :text
    remove_column :risks, :public_offence_related, :boolean
    remove_column :risks, :public_offence_related_details, :text
    remove_column :risks, :other_detainees, :boolean
    remove_column :risks, :other_detainees_details, :text
    remove_column :risks, :healthcare_staff, :boolean
    remove_column :risks, :healthcare_staff_details, :text
    remove_column :risks, :escort_or_court_staff, :boolean
    remove_column :risks, :escort_or_court_staff_details, :text
    remove_column :risks, :prison_staff, :boolean
    remove_column :risks, :prison_staff_details, :text
    remove_column :risks, :violent, :string
  end
end
