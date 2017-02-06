module Detainees
  class ImageFetcher < BaseFetcher
    def call
      return FetcherResponse.new({}) unless prison_number.present?
      fetch_image
      image_response
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

    def fetch_image
      log_api_request "Requesting image for offender with NOMS id #{prison_number}"
      @response = api_client.get("/offenders/#{prison_number}/image")
    end

    def image_response
      return error_response('not_found') unless response['image'].present?
      successful_response(response)
    end
  end
end
