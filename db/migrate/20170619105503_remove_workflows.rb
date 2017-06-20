class RemoveWorkflows < ActiveRecord::Migration[5.0]
  def change
    rename_column :workflows, :workflowable_id, :detainee_id
    remove_column :workflows, :type, :string
    rename_table :workflows, :offences_workflows
  end
end
