class ChangeRisks < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :self_harm, :string
    add_column :risks, :self_harm_details, :text

    change_column :risks, :gang_member, :string
    Risk.all.each { |risk| risk.update_column :gang_member, (risk.respond_to?(:gang_member_details) && risk.gang_member_details.present? ? 'yes' : 'no') }

    remove_column :risks, :intimidation_to_staff
    remove_column :risks, :intimidation_to_staff_details

    remove_column :risks, :violence_to_other_detainees
    remove_column :risks, :co_defendant
    remove_column :risks, :co_defendant_details
    remove_column :risks, :other_violence_to_other_detainees
    remove_column :risks, :other_violence_to_other_detainees_details
    remove_column :risks, :violence_to_general_public
    remove_column :risks, :violence_to_general_public_details
  end
end
