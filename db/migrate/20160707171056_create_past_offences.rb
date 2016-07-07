class CreatePastOffences < ActiveRecord::Migration[5.0]
  def change
    create_table :past_offences, id: :uuid do |t|
      t.uuid :offences_id
      t.string :offence
      t.timestamps
    end
  end
end
