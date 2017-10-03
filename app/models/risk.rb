class Risk < ApplicationRecord
  include Questionable
  include Reviewable
  act_as_assessment :risk, complex_attributes: %i[must_not_return_details]

  belongs_to :escort

  delegate :editable?, to: :escort

  def acct_status_alert_on?
    acct_status == 'open' || acct_status == 'post_closure'
  end

  def escape_risk_alert_on?
    current_e_risk == 'yes' || previous_escape_attempts == 'yes'
  end

  def active_alerts
    alerts = []
    alerts << :acct_status if acct_status_alert_on?
    alerts << :self_harm if self_harm == 'yes' || acct_status_alert_on?
    alerts << :rule_45 if rule_45 == 'yes'
    alerts << :current_e_risk if escape_risk_alert_on?
    alerts << :csra if csra == 'high'
    alerts << :category_a if category_a == 'yes'
    alerts
  end
end
