class OffencesWorkflowsInEscorts < ActiveRecord::Migration[5.0]
  def up
    add_column :offences_workflows, :escort_id, :uuid
    OffencesWorkflow.all.each { |ow| d = Detainee.find_by_id(ow.detainee_id); ow.update escort_id: d.escort_id if d }
    remove_column :offences_workflows, :detainee_id, :uuid
    add_index :offences_workflows, :escort_id
  end

  def down
    add_column :offences_workflows, :detainee_id, :uuid
    OffencesWorkflow.all.each { |ow| e = Escort.find_by_id(ow.escort_id); ow.update detainee_id: e.detainee.id if e&.detainee }
    remove_column :offences_workflows, :escort_id, :uuid
    add_index :offences_workflows, :detainee_id
  end
end
