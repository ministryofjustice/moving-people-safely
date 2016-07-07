class ChangeHasDestinationsToDestination < ActiveRecord::Migration[5.0]
  def change
    rename_column :moves, :has_destinations, :destination
  end
end
