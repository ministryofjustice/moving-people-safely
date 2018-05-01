class Risk < ApplicationRecord
  include Questionable
  include Reviewable

  SECTIONS = %w[risk_to_self segregation security harassment_and_gangs discrimination escape
                hostage_taker sex_offences concealed_weapons arson return_instructions other_risk].freeze
  MANDATORY_QUESTIONS = %w[acct_status self_harm csra rule_45 vulnerable_prisoner controlled_unlock
                           category_a high_profile pnc_warnings intimidation_public intimidation_prisoners
                           gang_member violence_to_staff risk_to_females homophobic racist
                           discrimination_to_other_religions other_violence_due_to_discrimination
                           current_e_risk previous_escape_attempts escape_pack escort_risk_assessment
                           hostage_taker sex_offence conceals_weapons uses_weapons conceals_drugs
                           conceals_mobile_phone_or_other_items substance_supply arson must_return
                           has_must_not_return_details other_risk].freeze
  RELEVANT_ANSWERS = %w[yes open post_closure closed high].freeze

  belongs_to :escort
  has_many :must_not_return_details, dependent: :destroy

  delegate :editable?, to: :escort

  def alerts
    {
      acct_status: acct_status_alert_on?,
      self_harm: (self_harm == 'yes' || acct_status_alert_on?),
      rule_45: (rule_45 == 'yes'),
      current_e_risk: (current_e_risk == 'yes' || previous_escape_attempts == 'yes'),
      csra: (csra == 'high'),
      category_a: (category_a == 'yes')
    }
  end

  def acct_status_text
    case acct_status
    when 'closed'
      "Closed: #{date_of_most_recently_closed_acct}"
    when 'none', nil
      nil
    else
      acct_status.humanize
    end
  end

  def acct_details
    "Closed: #{date_of_most_recently_closed_acct}" if acct_status == 'closed'
  end

  def must_return_details
    answer_details(must_return_to, must_return_to_details)
  end

  def relevant_questions
    @relevant_questions ||= MANDATORY_QUESTIONS.select do |question|
      RELEVANT_ANSWERS.include? public_send(question)
    end
  end

  private

  def acct_status_alert_on?
    acct_status == 'open' || acct_status == 'post_closure'
  end
end
