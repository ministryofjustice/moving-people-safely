module Detainees
  class ImageFetcher < BaseFetcher
    def call
      with_error_handling do
        return empty_response unless prison_number.present?

        fetch_image
        image_response
      end
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
