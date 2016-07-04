class AddViolenceToRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :violent, :string, default: 'unknown'
    add_column :risks, :prison_staff, :boolean
    add_column :risks, :prison_staff_details, :text
    add_column :risks, :risk_to_females, :boolean
    add_column :risks, :risk_to_females_details, :text
    add_column :risks, :escort_or_court_staff, :boolean
    add_column :risks, :escort_or_court_staff_details, :text
    add_column :risks, :healthcare_staff, :boolean
    add_column :risks, :healthcare_staff_details, :text
    add_column :risks, :other_detainees, :boolean
    add_column :risks, :other_detainees_details, :text
    add_column :risks, :homophobic, :boolean
    add_column :risks, :homophobic_details, :text
    add_column :risks, :racist, :boolean
    add_column :risks, :racist_details, :text
    add_column :risks, :public_offence_related, :boolean
    add_column :risks, :public_offence_related_details, :text
    add_column :risks, :police, :boolean
    add_column :risks, :police_details, :text
  end
end
