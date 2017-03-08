module Print
  class MoveAlertsPresenter < SimpleDelegator
    def initialize(object, view_context)
      super(object)
      @view_context = view_context
    end

    RISK_ATTRIBUTES = %i[
      acct_status date_of_most_recently_closed_acct rule_45
      current_e_risk current_e_risk_details csra category_a
    ].freeze
    delegate(:detainee, to: :model)
    delegate(:risk, :healthcare, to: :detainee)
    delegate(*RISK_ATTRIBUTES, to: :risk, allow_nil: true)
    delegate(:mpv, to: :healthcare, allow_nil: true)

    def not_for_release_alert
      status = not_for_release == 'yes' ? :on : :off
      alert_for(:not_for_release, status: status, text: not_for_release_text)
    end

    def not_for_release_text
      return unless not_for_release == 'yes'
      text = localised_attr_value(:not_for_release_reason)
      text << " (#{not_for_release_reason_details})" if not_for_release_reason == 'other'
      text
    end

    def acct_status_alert
      alert_for(:acct_status, status: acct_status_status, text: acct_status_text)
    end

    def acct_status_status
      return :on if %w[open post_closure].include?(acct_status)
      :off
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

    def rule_45_alert
      status = rule_45 == 'yes' ? :on : :off
      alert_for(:rule_45, status: status)
    end

    def current_e_risk_alert
      alert_for(:current_e_risk, status: current_e_risk_status, text: current_e_risk_text)
    end

    def current_e_risk_status
      return :off if current_e_risk != 'yes'
      return :on if %w[e_list_standard e_list_escort e_list_heightened].include?(current_e_risk_details)
      :off
    end

    def current_e_risk_text
      return unless current_e_risk == 'yes'
      return unless current_e_risk_details.present?
      localised_attr_value(:current_e_risk_details)
    end

    def csra_alert
      status = csra == 'high' ? :on : :off
      alert_for(:csra, status: status, text: csra_text)
    end

    def csra_text
      csra == 'high' ? 'High' : 'Standard'
    end

    def category_a_alert
      status = category_a == 'yes' ? :on : :off
      alert_for(:category_a, status: status)
    end

    def mpv_alert
      status = mpv == 'yes' ? :on : :off
      alert_for(:mpv, status: status)
    end

    private

    attr_reader :view_context
    alias h view_context

    def alert_for(attr, options)
      Print::AlertPresenter.new(attr, options.merge(view_context: view_context)).to_s
    end

    def localised_attr_value(attr)
      value = public_send(attr)
      h.t("print.alerts.#{attr}.#{value}", default: value.humanize)
    end

    def model
      __getobj__
    end
  end
end
