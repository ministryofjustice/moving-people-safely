class CreateCurrentOffences < ActiveRecord::Migration[5.0]
  def change
    create_table :current_offences, id: :uuid do |t|
      t.uuid    :offences_id, null: false
      t.string  :offence
      t.string  :case_reference

      t.timestamps null: false
    end
  end
end
