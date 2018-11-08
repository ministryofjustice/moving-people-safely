# frozen_string_literal: true

module Detainees
  class ScheduledMoveMapper
    def initialize(alerts)
      @alerts = alerts['alerts']
    end

    def call
      ALERT_CODES.keys.map { |key| [key, alert_value(ALERT_CODES[key])] }.to_h.with_indifferent_access
    end

    private

    attr_reader :alerts, :move_date

    ALERT_CODES = {
      violent: %w[XVL],
      suicide: %w[HA HA1],
      self_harm: %w[HA HA1 HC HS],
      escape_risk: %w[XEL XER],
      segregation: %w[V45 V46 V49G V49P VJOP VOP],
      medical: %w[M]
    }.freeze

    def alert_value(codes)
      alerts_for_codes(codes) ? 'yes' : 'no'
    end

    def alerts_for_codes(codes)
      alerts.any? { |alert| codes.include? alert['alert_sub_type']['code'] }
    end
  end
end
