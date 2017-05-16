class RemoveViolenceToStaffExtraColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :violence_to_staff_custody, :boolean
    remove_column :risks, :violence_to_staff_community, :boolean
  end
end
