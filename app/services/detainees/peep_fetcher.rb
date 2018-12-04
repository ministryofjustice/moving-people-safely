# frozen_string_literal: true

module Detainees
  class PeepFetcher < BaseFetcher
    def call
      with_error_handling do
        return empty_response unless prison_number.present?

        fetch_alerts
        successful_response(peep_attrs)
      end
    end

    private

    def fetch_alerts
      log_api_request "Requesting alerts for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}/alerts")
    end

    def peep_attrs
      { peep: (peep_alert ? 'yes' : 'no'), peep_details: peep_alert&.fetch('comment') }
    end

    def peep_alert
      @response['alerts'].find { |alert| alert['alert_sub_type']['code'] == 'PEEP' }
    end
  end
end
