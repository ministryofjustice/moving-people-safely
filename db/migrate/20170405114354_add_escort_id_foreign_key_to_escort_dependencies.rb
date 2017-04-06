class AddEscortIdForeignKeyToEscortDependencies < ActiveRecord::Migration[5.0]
  def change
    add_column :detainees, :escort_id, :uuid
    add_index :detainees, :escort_id
    add_column :moves, :escort_id, :uuid
    add_index :moves, :escort_id
  end
end
