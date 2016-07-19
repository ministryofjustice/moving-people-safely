class Risks < ApplicationRecord
  include Questionable

  QUESTION_FIELDS =
    %w[ open_acct suicide rule_45 csra verbal_abuse physical_abuse violent
        stalker_harasser_bully sex_offence non_association_markers
        current_e_risk escape_list other_escape_risk_info category_a
        restricted_status drugs alcohol conceals_weapons arson
        damage_to_property interpreter_required hearing_speach_sight
        can_read_and_write  ]

  belongs_to :escort

  def question_fields
    QUESTION_FIELDS
  end

  def complete?
    workflow_status == 'complete'
  end
end
