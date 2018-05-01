class RenameRiskFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :risks, :controlled_unlock_required, :controlled_unlock
    rename_column :risks, :sex_offences_details, :sex_offence_details
    rename_column :risks, :must_not_return, :has_must_not_return_details
  end
end
