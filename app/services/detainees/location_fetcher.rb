# frozen_string_literal: true

module Detainees
  class LocationFetcher < BaseFetcher
    def call
      with_error_handling do
        return empty_response unless prison_number.present?
        fetch_location
        successful_response(location_attrs)
      end
    end

    private

    def fetch_location
      log_api_request "Requesting details for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}/location")
    end

    def location_attrs
      establishment = response['establishment']
      return {} unless establishment
      {
        code: establishment['code'],
        desc: establishment['desc']
      }.with_indifferent_access
    end
  end
end
