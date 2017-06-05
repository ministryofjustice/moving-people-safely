class RemoveObsoleteHealthcareColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :healthcare, :detainee_id, :uuid
  end
end
