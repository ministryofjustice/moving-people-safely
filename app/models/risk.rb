class Risk < ApplicationRecord
  include Questionable
  include Reviewable

  RELEVANT_ANSWERS = %w[yes open post_closure closed high].freeze

  belongs_to :escort
  has_many :must_not_return_details, dependent: :destroy

  delegate :editable?, :location, to: :escort

  def alerts
    {
      acct_status: acct_status_alert_on?,
      self_harm: (self_harm == 'yes' || acct_status_alert_on?),
      csra: (csra == 'high' || csra == 'yes'),
      rule_45: (rule_45 == 'yes'),
      violent: (violent_or_dangerous == 'yes'),
      current_e_risk: (current_e_risk == 'yes' || previous_escape_attempts == 'yes'),
      sex_offender: (sex_offence == 'yes')
    }
  end

  def relevant_questions
    Risk.mandatory_questions(location).select do |question|
      RELEVANT_ANSWERS.include? public_send(question)
    end
  end

  private

  def acct_status_alert_on?
    acct_status == 'open' || acct_status == 'post_closure'
  end
end
