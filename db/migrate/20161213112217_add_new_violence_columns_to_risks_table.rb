class AddNewViolenceColumnsToRisksTable < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :violence_due_to_discrimination, :string
    add_column :risks, :other_violence_due_to_discrimination, :boolean
    add_column :risks, :other_violence_due_to_discrimination_details, :text
    add_column :risks, :violence_to_staff, :string
    add_column :risks, :violence_to_staff_custody, :boolean
    add_column :risks, :violence_to_staff_community, :boolean
    add_column :risks, :violence_to_other_detainees, :string
    add_column :risks, :co_defendant, :boolean
    add_column :risks, :co_defendant_details, :text
    add_column :risks, :gang_member, :boolean
    add_column :risks, :gang_member_details, :text
    add_column :risks, :other_violence_to_other_detainees, :boolean
    add_column :risks, :other_violence_to_other_detainees_details, :text
    add_column :risks, :violence_to_general_public, :string
    add_column :risks, :violence_to_general_public_details, :text
  end
end
