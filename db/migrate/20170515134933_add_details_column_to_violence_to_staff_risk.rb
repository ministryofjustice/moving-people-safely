class AddDetailsColumnToViolenceToStaffRisk < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :violence_to_staff_details, :text
  end
end
