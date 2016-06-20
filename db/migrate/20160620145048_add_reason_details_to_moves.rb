class AddReasonDetailsToMoves < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :reason_details, :text
  end
end
