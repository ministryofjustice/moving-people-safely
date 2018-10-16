# frozen_string_literal: true

module Detainees
  class DetailsFetcher < BaseFetcher
    def call
      with_error_handling do
        return empty_response unless prison_number.present?
        fetch_details
        successful_response(detainee_attrs)
      end
    end

    private

    def fetch_details
      log_api_request "Requesting details for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}")
    end

    def detainee_attrs
      DetailsMapper.new(prison_number, response).call
    end
  end
end
