class AddWorkflowStatusToEscort < ActiveRecord::Migration[5.0]
  def change
    add_column :escorts, :workflow_status, :string, default: 'not_started'
  end
end
