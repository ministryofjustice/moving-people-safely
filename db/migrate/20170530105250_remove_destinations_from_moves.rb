class RemoveDestinationsFromMoves < ActiveRecord::Migration[5.0]
  def change
    remove_column :moves, :has_destinations, :string
    drop_table :destinations, id: :uuid do |t|
      t.uuid :move_id
      t.string :establishment
      t.string :must_return, default: 'unknown'
      t.text :reasons

      t.timestamps
    end
  end
end
