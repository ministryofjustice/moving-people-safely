class Risk < ApplicationRecord
  include Questionable
  include Reviewable
  act_as_assessment :risk, complex_attributes: %i[must_not_return_details]

  belongs_to :escort

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
    when 'closed_in_last_6_months'
      "Closed: #{date_of_most_recently_closed_acct}"
    when 'none'
      ''
    else
      acct_status.humanize
    end
  end

  private

  def acct_status_alert_on?
    acct_status == 'open' || acct_status == 'post_closure'
  end
end
