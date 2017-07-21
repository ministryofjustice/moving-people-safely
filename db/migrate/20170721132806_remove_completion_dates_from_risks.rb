class RemoveCompletionDatesFromRisks < ActiveRecord::Migration[5.0]
  def change
    remove_column :risks, :escort_risk_assessment_completion_date, :date
    remove_column :risks, :escape_pack_completion_date, :date
  end
end
