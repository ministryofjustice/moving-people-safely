class AddNotForReleaseColumnsToMoves < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :not_for_release, :string
    add_column :moves, :not_for_release_reason, :string
    add_column :moves, :not_for_release_reason_details, :text
  end
end
