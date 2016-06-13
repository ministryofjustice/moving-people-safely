class CreateHealthcare < ActiveRecord::Migration[5.0]
  def change
    create_table :healthcare, id: :uuid do |t|
      t.uuid   :escort_id
      t.string :physical_issues, default: 'unknown'
      t.text   :physical_issues_details
      t.string :mental_illness, default: 'unknown'
      t.text   :mental_illness_details
      t.string :phobias, default: 'unknown'
      t.text   :phobias_details
      t.string :personal_hygiene, default: 'unknown'
      t.text   :personal_hygiene_details
      t.string :personal_care, default: 'unknown'
      t.text   :personal_care_details
      t.string :allergies, default: 'unknown'
      t.text   :allergies_details
      t.string :dependencies, default: 'unknown'
      t.text   :dependencies_details
      t.string :medication, default: 'unknown'
      t.string :mpv, default: 'unknown'
      t.text   :mpv_details
      t.string :clinician_name
      t.string :contact_number

      t.timestamps null: false
    end
  end
end
