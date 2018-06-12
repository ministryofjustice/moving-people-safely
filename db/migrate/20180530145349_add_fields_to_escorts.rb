class AddFieldsToEscorts < ActiveRecord::Migration[5.2]
  def change
    add_column :escorts, :date, :date
    add_column :escorts, :from_establishment_id, :uuid
    add_column :escorts, :to, :string
    add_column :escorts, :to_type, :string

    add_column :escorts, :forenames, :string
    add_column :escorts, :surname, :string
    add_column :escorts, :date_of_birth, :date
    add_column :escorts, :gender, :string
    add_column :escorts, :nationalities, :text
    add_column :escorts, :pnc_number, :string
    add_column :escorts, :cro_number, :string
    add_column :escorts, :aliases, :text
    add_column :escorts, :ethnicity, :string
    add_column :escorts, :religion, :string
    add_column :escorts, :language, :string
    add_column :escorts, :interpreter_required, :string
    add_column :escorts, :diet, :string
    add_column :escorts, :peep, :string
    add_column :escorts, :peep_details, :text
    add_column :escorts, :image_filename, :string, default: ""
    add_column :escorts, :image, :binary

    add_column :escorts, :not_for_release, :string
    add_column :escorts, :not_for_release_reason, :string
    add_column :escorts, :not_for_release_reason_details, :text

    Escort.includes(:detainee).each { |e| e.update_columns e.detainee.attributes.except('created_at', 'updated_at', 'escort_id', 'id') if e.detainee }
    Escort.includes(:move).each { |e| e.update_columns e.move.attributes.except('created_at', 'updated_at', 'escort_id', 'id') if e.move }
  end
end
