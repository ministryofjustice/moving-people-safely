module Detainees
  class RiskMapper
    def initialize(alerts, move_date)
      @alerts = alerts['alerts']
      @move_date = move_date
    end

    def call
      {
        self_harm: alert_value(ALERT_CODES[:self_harm]),
        self_harm_details: alert_comments(ALERT_CODES[:self_harm]),
        rule_45: alert_value(ALERT_CODES[:rule_45]),
        vulnerable_prisoner: alert_value(ALERT_CODES[:vulnerable_prisoner]),
        vulnerable_prisoner_details: alert_comments(ALERT_CODES[:vulnerable_prisoner]),
        controlled_unlock: alert_value(ALERT_CODES[:controlled_unlock]),
        high_profile: alert_value(ALERT_CODES[:high_profile]),
        high_profile_details: alert_comments(ALERT_CODES[:high_profile]),
        intimidation: alert_value(ALERT_CODES[:intimidation]),
        intimidation_to_public: alert_value(ALERT_CODES[:intimidation_to_public], return_type: :boolean),
        intimidation_to_public_details: alert_comments(ALERT_CODES[:intimidation_to_public]),
        intimidation_to_other_detainees: alert_value(ALERT_CODES[:intimidation_to_other_detainees], return_type: :boolean),
        intimidation_to_other_detainees_details: alert_comments(ALERT_CODES[:intimidation_to_other_detainees]),
        gang_member: alert_value(ALERT_CODES[:gang_member]),
        gang_member_details: alert_comments(ALERT_CODES[:gang_member]),
        violence_to_staff: alert_value(ALERT_CODES[:violence_to_staff]),
        violence_to_staff_details: alert_comments(ALERT_CODES[:violence_to_staff]),
        risk_to_females: alert_value(ALERT_CODES[:risk_to_females]),
        risk_to_females_details: alert_comments(ALERT_CODES[:risk_to_females]),
        homophobic: alert_value(ALERT_CODES[:homophobic]),
        homophobic_details: alert_comments(ALERT_CODES[:homophobic]),
        racist: alert_value(ALERT_CODES[:racist]),
        racist_details: alert_comments(ALERT_CODES[:racist]),
        discrimination_to_other_religions: alert_value(ALERT_CODES[:discrimination_to_other_religions]),
        discrimination_to_other_religions_details: alert_comments(ALERT_CODES[:discrimination_to_other_religions]),
        other_violence_due_to_discrimination: alert_value(ALERT_CODES[:other_violence_due_to_discrimination], set_negative: false),
        other_violence_due_to_discrimination_details: alert_comments(ALERT_CODES[:other_violence_due_to_discrimination]),
        current_e_risk: alert_value(ALERT_CODES[:current_e_risk]),
        current_e_risk_details: alert_comments(ALERT_CODES[:current_e_risk]),
        previous_escape_attempts: alert_value(ALERT_CODES[:previous_escape_attempts]),
        previous_escape_attempts_details: alert_comments(ALERT_CODES[:previous_escape_attempts]),
        hostage_taker: alert_value(ALERT_CODES[:hostage_taker]),
        sex_offence: alert_value(ALERT_CODES[:sex_offence]),
        arson: alert_value(ALERT_CODES[:arson]),
        must_return: alert_value(ALERT_CODES[:must_return]),
        must_return_to_details: alert_comments(ALERT_CODES[:must_return]),
        has_must_not_return_details: alert_value(ALERT_CODES[:has_must_not_return_details]),
        # must_not_return_details: alert_comments(ALERT_CODES[:must_not_return]),
        other_risk: alert_value(ALERT_CODES[:other_risk]),
        other_risk_details: alert_comments(ALERT_CODES[:other_risk])
      }.select { |_k, v| v.present? || v == false }.with_indifferent_access
    end

    private

    attr_reader :alerts, :move_date

    ALERT_CODES = {
      self_harm: %w[HC HS SH],
      rule_45: %w[V45 VOP],
      vulnerable_prisoner: %w[VI VIP VJOP VOP VU XYA],
      controlled_unlock: %w[XCU],
      high_profile: %w[HPI XPOI],
      intimidation: %w[OHA OHCO ONCR OCVM XCH XB XVL RDV RSP RCS RKC RPB RPC RKS],
      intimidation_to_public: %w[OHA OHCO ONCR XCH RDV RSP RKC RPB RPC],
      intimidation_to_other_detainees: %w[OCVM XB XVL RKS],
      gang_member: %w[XGANG XOCGN],
      violence_to_staff: %w[RSS RST XSA SA],
      risk_to_females: %w[XRF],
      homophobic: %w[RLG RTP],
      racist: %w[XR],
      discrimination_to_other_religions: %w[RRV REG],
      other_violence_due_to_discrimination: %w[C1 C2 C3 C4 CC1 CC2 CC3 CC4 RCC RCS RDP ROP RYP SC XCC CPRC P0 P1
                                               P2 P3 PC2 PC3 CPC PL1 PL2 PL3 PVN RVR SE SSHO ROM ROH ROV XEBM],
      current_e_risk: %w[XEL],
      previous_escape_attempts: %w[XER XC],
      hostage_taker: %w[XHT],
      sex_offence: %w[XSO SO SONR SOR SR PC1],
      arson: %w[XA],
      must_return: %w[TAH TAP TG TM TPR TSE],
      has_must_not_return_details: %w[TCPA],
      other_risk: %w[XTACT]
    }.freeze

    def alert_value(codes, return_type: :string, set_negative: true)
      if alerts_for_codes(codes).any?
        return 'yes' if return_type == :string
        return true if return_type == :boolean
      else
        if set_negative
          return 'no' if return_type == :string
          return false if return_type == :boolean
        end
      end
    end

    def alert_comments(codes)
      alerts_for_codes(codes).map { |alert| alert['comment'] }.compact.join(' | ')
    end

    def alerts_for_codes(codes)
      active_alerts.select { |alert| codes.include? alert['alert_sub_type']['code'] }
    end

    def active_alerts
      @_active_alerts ||= alerts.select do |alert|
        next unless alert['alert_date']
        alert_date = Date.parse(alert['alert_date'])

        if alert['expiry_date']
          expiry_date = Date.parse(alert['expiry_date'])
          alert_date <= move_date && move_date <= expiry_date
        else
          alert_date <= move_date
        end
      end
    end
  end
end
