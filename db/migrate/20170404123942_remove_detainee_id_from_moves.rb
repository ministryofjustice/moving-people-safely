class RemoveDetaineeIdFromMoves < ActiveRecord::Migration[5.0]
  def change
    remove_column :moves, :detainee_id, :uuid
  end
end
