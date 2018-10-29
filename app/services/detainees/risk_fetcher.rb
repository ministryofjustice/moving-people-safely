module Detainees
  class RiskFetcher < BaseFetcher
    def call
      with_error_handling do
        return empty_response unless prison_number.present?

        fetch_risk
        successful_response(mapped_risk)
      end
    end

    private

    def fetch_risk
      log_api_request "Requesting alerts for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}/alerts?include_inactive=true")
    end

    def mapped_risk
      RiskMapper.new(response, move_date).call
    end
  end
end
