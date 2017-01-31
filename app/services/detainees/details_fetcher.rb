module Detainees
  class DetailsFetcher < BaseFetcher
    def call
      return FetcherResponse.new({}) unless prison_number.present?
      fetch_details
      successful_response(detainee_attrs)
    rescue Nomis::HttpError => e
      log_api_error(e.inspect)
      error_code = error_code_for_http_status(e.response.status)
      error_response(error_code)
    rescue Nomis::ApiError => e
      log_api_error(e.inspect)
      error_response('api_error')
    rescue => e
      log_error("Internal error: #{e.inspect}")
      error_response('internal_error')
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
