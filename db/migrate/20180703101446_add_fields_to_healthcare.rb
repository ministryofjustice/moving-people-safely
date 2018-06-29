class AddFieldsToHealthcare < ActiveRecord::Migration[5.2]
  def change
    add_column :healthcare, :pregnant, :string
    add_column :healthcare, :pregnant_details, :text
    add_column :healthcare, :alcohol_withdrawal, :string
    add_column :healthcare, :alcohol_withdrawal_details, :text
    add_column :healthcare, :female_hygiene_kit, :string
    add_column :healthcare, :female_hygiene_kit_details, :text
  end
end
