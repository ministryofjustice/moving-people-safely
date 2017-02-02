class DetaineeDetailsFetcher
  def initialize(prison_number)
    @prison_number = prison_number
  end

  def call
    return Response.new({}) unless prison_number.present?
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

  class Response
    attr_reader :details, :error
    delegate :[], to: :details

    def initialize(details, options = {})
      @details = details
      @error = options[:error]
    end
  end

  private

  attr_reader :prison_number, :offenders_search_path, :response

  def api_client
    @api_client ||= Nomis::Api.instance
  end

  def fetch_details
    log_api_request "Requesting details for offender with NOMS id #{prison_number}"
    @response = api_client.get("/offenders/#{prison_number}")
  end

  def successful_response(details)
    Response.new(details)
  end

  def error_response(error_code)
    Response.new({}, error: error_code)
  end

  def detainee_attrs
    ApiDetaineeDetailsMapper.new(prison_number, response).call
  end

  def error_code_for_http_status(http_status)
    {
      404 => 'details_not_found',
      400 => 'invalid_input'
    }[http_status] || 'api_error'
  end

  def log_error(message)
    Rails.logger.error "[DetaineeDetailsFetcher] #{message}"
  end

  def log_api_request(message)
    Rails.logger.info "[DetaineeDetailsFetcher] NOMIS API: #{message}"
  end

  def log_api_error(message)
    log_error "NOMIS API Error: #{message}"
  end
end
