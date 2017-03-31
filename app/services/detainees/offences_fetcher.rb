module Detainees
  class OffencesFetcher < BaseFetcher
    def call
      with_error_handling do
        fetch_offences
        successful_response(mapped_offences)
      end
    end

    private

    def fetch_offences
      log_api_request "Requesting offences for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}/charges")
    end

    def mapped_offences
      OffencesMapper.new(response).call
    end
  end
end
