class RemoveNotForReleaseColumnsFromOffences < ActiveRecord::Migration[5.0]
  def change
    remove_column :offences, :release_date
    remove_column :offences, :not_for_release
    remove_column :offences, :not_for_release_details
  end
end
