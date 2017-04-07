class MigrateOffencesToCurrentOffences < ActiveRecord::Migration[5.0]
  def change
    add_column :current_offences, :detainee_id, :uuid
    assosciate_existing_current_offences_with_detainee
    remove_column :current_offences, :offences_id
    drop_table :offences
    add_index :current_offences, :detainee_id
  end

  private

  def assosciate_existing_current_offences_with_detainee
    execute """
      UPDATE current_offences co
      SET detainee_id = o.detainee_id
      FROM offences o
      WHERE o.id = co.offences_id
    """
  end
end
