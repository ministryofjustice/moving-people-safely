class ChangeMedicationToHasMedications < ActiveRecord::Migration[5.0]
  def change
    rename_column :healthcare, :medication, :has_medications
  end
end
