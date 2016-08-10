class RemoveWorkflowColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :workflow_status
    remove_column :healthcare, :workflow_status
    remove_column :offences, :workflow_status
  end
end
