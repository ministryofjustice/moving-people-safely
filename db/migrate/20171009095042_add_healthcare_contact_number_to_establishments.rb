class AddHealthcareContactNumberToEstablishments < ActiveRecord::Migration[5.0]
  def change
    add_column :establishments, :healthcare_contact_number, :string
  end
end
