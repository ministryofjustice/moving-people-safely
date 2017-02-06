module Detainees
  class BaseFetcher
    def initialize(prison_number, options = {})
      @prison_number = prison_number
      @logger = options.fetch(:logger) { Rails.logger }
      @api_client = options.fetch(:api_client) { Nomis::Api.instance }
    end

    def call
      raise NotImplementedError, 'implement in inherited class'
    end

    private

    attr_reader :prison_number, :logger, :api_client, :response

    def successful_response(hash)
      FetcherResponse.new(hash)
    end

    def error_response(error_code)
      FetcherResponse.new({}, error: error_code)
    end

    def error_code_for_http_status(http_status)
      {
        404 => 'not_found',
        400 => 'invalid_input'
      }[http_status] || 'api_error'
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
