class AddSecurityRiskNewColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :risks, :previous_escape_attempts, :string
    add_column :risks, :prison_escape_attempt, :boolean
    add_column :risks, :prison_escape_attempt_details, :text
    add_column :risks, :court_escape_attempt, :boolean
    add_column :risks, :court_escape_attempt_details, :text
    add_column :risks, :police_escape_attempt, :boolean
    add_column :risks, :police_escape_attempt_details, :text
    add_column :risks, :other_type_escape_attempt, :boolean
    add_column :risks, :other_type_escape_attempt_details, :text
    add_column :risks, :escort_risk_assessment, :string
    add_column :risks, :escort_risk_assessment_completion_date, :date
    add_column :risks, :escape_pack, :string
    add_column :risks, :escape_pack_completion_date, :date
  end
end
