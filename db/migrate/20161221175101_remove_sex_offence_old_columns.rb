class RemoveSexOffenceOldColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :sex_offence_victim
    remove_column :risks, :sex_offence_details
  end
end
