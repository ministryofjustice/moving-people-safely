require 'countries'

class DetaineeDetailsFetcher
  class ApiError < StandardError; end

  def initialize(prison_number)
    @prison_number = prison_number
    @offenders_search_path = '/offenders/search'
  end

  def call
    return Response.new({}) unless prison_number.present?
    fetch_details
    return error_response('api_error') unless response.status == 200
    return error_response('details_not_found') unless parsed_response
    successful_response(detainee_attrs)
  rescue ApiError
    error_response('api_error')
  rescue => e
    Rails.logger.error "[OffendersApi] #{e.inspect}"
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

  def fetch_details
    Rails.logger.info "[OffendersApi] Requesting to #{offenders_search_path} for offender with noms id #{prison_number}"
    @response = Rails.offenders_api_client.get(offenders_search_path, params: { noms_id: prison_number })
  rescue => e
    Rails.logger.error "[OffendersApi] #{e.inspect}"
    raise ApiError
  end

  def successful_response(details)
    Response.new(details)
  end

  def error_response(error_code)
    Response.new({}, error: error_code)
  end

  def parsed_response
    return unless response
    @parsed_response ||= JSON.parse(response.body).first
  rescue => e
    Rails.logger.error e.inspect
    raise ApiError
  end

  def detainee_attrs
    ApiDetaineeDetailsMapper.new(prison_number, parsed_response).call
  end
end
