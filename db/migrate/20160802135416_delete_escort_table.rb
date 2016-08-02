class DeleteEscortTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :escorts
    remove_column :detainees, :escort_id
    remove_column :healthcare, :escort_id
    remove_column :risks, :escort_id
    remove_column :moves, :escort_id
    remove_column :offences, :escort_id
  end
end
