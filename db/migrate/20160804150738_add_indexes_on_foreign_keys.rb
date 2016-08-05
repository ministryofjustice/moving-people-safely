class AddIndexesOnForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_index :risks, :detainee_id
    add_index :healthcare, :detainee_id
    add_index :medications, :healthcare_id
    add_index :offences, :detainee_id
    add_index :current_offences, :offences_id
    add_index :past_offences, :offences_id
    add_index :moves, :detainee_id
    add_index :destinations, :move_id
    add_index :workflows, :move_id
    add_index :workflows, :type
  end
end
