class RenameNotForReleaseReasonFieldToNotForReleaseDetails < ActiveRecord::Migration[5.0]
  def change
    rename_column :offences, :not_for_release_reason, :not_for_release_details
  end
end
