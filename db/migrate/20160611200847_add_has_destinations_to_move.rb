class AddHasDestinationsToMove < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :has_destinations, :string, default: 'unknown'
  end
end
