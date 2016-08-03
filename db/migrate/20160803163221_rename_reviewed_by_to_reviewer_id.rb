class RenameReviewedByToReviewerId < ActiveRecord::Migration[5.0]
  def change
    remove_column :workflows, :reviewed_by
    add_column :workflows, :reviewer_id, :integer
  end
end
