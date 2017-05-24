class RemoveHealthcareProfessionalFromHealthcare < ActiveRecord::Migration[5.0]
  def change
    remove_column :healthcare, :healthcare_professional, :string
  end
end
