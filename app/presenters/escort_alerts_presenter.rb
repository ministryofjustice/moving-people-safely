class EscortAlertsPresenter < SimpleDelegator
  MOVE_ATTRIBUTES = %i[
    not_for_release not_for_release_reason
    not_for_release_reason_details
  ].freeze
  RISK_ATTRIBUTES = %i[
    acct_status date_of_most_recently_closed_acct rule_45
    current_e_risk current_e_risk_details csra category_a
  ].freeze

  delegate(*MOVE_ATTRIBUTES, to: :move, allow_nil: true)
  delegate(*RISK_ATTRIBUTES, to: :risk, allow_nil: true)
  delegate(:mpv, to: :healthcare, allow_nil: true)

  def not_for_release_alert_class
    not_for_release == 'yes' ? 'alert-on' : 'alert-off'
  end

  def not_for_release_text
    return unless not_for_release == 'yes'
    text = localised_attr_value(:not_for_release_reason)
    text << " (#{not_for_release_reason_details})" if not_for_release_reason == 'other'
    text
  end

  def acct_status_alert_class
    case acct_status
    when 'open', 'post_closure'
      'alert-on'
    else
      'alert-off'
    end
  end

  def acct_status_text
    return unless acct_status.present?
    case acct_status
    when 'closed_in_last_6_months'
      [
        localised_attr_value(:acct_status),
        date_of_most_recently_closed_acct
      ].join(' ')
    else
      localised_attr_value(:acct_status)
    end
  end

  def rule_45_alert_class
    rule_45 == 'yes' ? 'alert-on' : 'alert-off'
  end

  def current_e_risk_alert_class
    return 'alert-off' if current_e_risk != 'yes'
    return 'alert-on' if %w[e_list_standard e_list_escort e_list_heightened].include?(current_e_risk_details)
    'alert-off'
  end

  def current_e_risk_text
    return unless current_e_risk == 'yes'
    return unless current_e_risk_details.present?
    localised_attr_value(:current_e_risk_details)
  end

  def csra_alert_class
    csra == 'high' ? 'alert-on' : 'alert-off'
  end

  def csra_text
    csra == 'high' ? 'High' : 'Standard'
  end

  def category_a_alert_class
    category_a == 'yes' ? 'alert-on' : 'alert-off'
  end

  def mpv_alert_class
    mpv == 'yes' ? 'alert-on' : 'alert-off'
  end

  private

  def localised_attr_value(attr)
    value = public_send(attr)
    I18n.t("escort.alerts.#{attr}.#{value}", default: value.humanize)
  end
end
