class CreateDetainees < ActiveRecord::Migration[5.0]
  def change
    create_table :detainees, id: :uuid do |t|
      t.uuid :escort_id
      t.string :forenames
      t.string :surname
      t.date   :date_of_birth
      t.string :gender
      t.string :prison_number
      t.text   :nationalities
      t.string :pnc_number
      t.string :cro_number
      t.text   :aliases

      t.timestamps
    end
  end
end
