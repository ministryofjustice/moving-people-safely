class AddWorkflowFields < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :status, :integer, default: 0
    add_column :risks, :reviewer_id, :integer
    add_column :risks, :reviewed_at, :datetime

    add_column :healthcare, :status, :integer, default: 0
    add_column :healthcare, :reviewer_id, :integer
    add_column :healthcare, :reviewed_at, :datetime

    rename_column :workflows, :move_id, :workflowable_id
  end
end
