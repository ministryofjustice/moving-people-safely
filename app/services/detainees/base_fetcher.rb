# frozen_string_literal: true

module Detainees
  class BaseFetcher
    def initialize(prison_number, options = {})
      @prison_number = prison_number
      @logger = options.fetch(:logger) { Rails.logger }
      @api_client = options.fetch(:api_client) { Nomis::Api.instance }
      @move_date = options.fetch(:move_date) { Date.current }
    end

    def call
      raise NotImplementedError, 'implement in inherited class'
    end

    private

    attr_reader :prison_number, :logger, :api_client, :response, :move_date

    def successful_response(hash)
      FetcherResponse.new(hash)
    end

    def error_response(error_code)
      FetcherResponse.new({}, error: error_code)
    end

    def empty_response
      FetcherResponse.new({})
    end

    def error_code_for_http_status(http_status)
      {
        404 => 'not_found',
        400 => 'invalid_input'
      }[http_status] || 'api_error'
    end

    def with_error_handling(&_blk)
      yield
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

    def log(message, options = {})
      severity = options.fetch(:severity, :info)
      prefix = options[:prefix]
      log_message = ["[#{self.class.name}]", prefix, message].compact.join(' ')
      logger.public_send(severity, log_message)
    end

    def log_error(message)
      log(message, severity: :error)
    end

    def log_api_request(message)
      log(message, prefix: 'NOMIS API:')
    end

    def log_api_error(message)
      log(message, severity: :error, prefix: 'NOMIS API:')
    end
  end
end
