class RemoveReasonColumnsFromMoves < ActiveRecord::Migration[5.0]
  def change
    remove_column :moves, :reason
    remove_column :moves, :reason_details
  end
end
