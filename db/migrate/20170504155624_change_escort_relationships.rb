class ChangeEscortRelationships < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :escort_id, :uuid
    add_index :risks, :escort_id
    add_column :healthcare, :escort_id, :uuid
    add_index :healthcare, :escort_id
  end
end
