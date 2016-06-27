class ChangeClinicianToProgessional < ActiveRecord::Migration[5.0]
  def change
    rename_column :healthcare, :clinician_name, :healthcare_professional
  end
end
