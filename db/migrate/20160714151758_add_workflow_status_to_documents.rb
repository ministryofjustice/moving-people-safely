class AddWorkflowStatusToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :healthcare, :workflow_status, :string, default: 'not_started'
    add_column :risks, :workflow_status, :string, default: 'not_started'
    add_column :offences, :workflow_status, :string, default: 'not_started'
  end
end
