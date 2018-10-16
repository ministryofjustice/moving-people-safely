# frozen_string_literal: true

require 'excon'

module Nomis
  ApiError = Class.new(StandardError)
  class HttpError < ApiError
    attr_reader :response

    def initialize(response)
      @response = response
    end
  end

  class Client
    TIMEOUT = 2 # seconds

    def initialize(host, client_token, client_key, options = {})
      @host = host
      @client_token = client_token
      @client_key = client_key

      @connection = Excon.new(host, default_options.merge(options))
    end

    def get(route, params = {})
      request(:get, route, params, idempotent: true)
    end

    private

    attr_reader :host, :client_token, :client_key, :connection

    def default_options
      {
        persistent: true,
        connect_timeout: TIMEOUT,
        read_timeout: TIMEOUT,
        write_timeout: TIMEOUT
      }
    end

    def request(method, route, params, idempotent:)
      options = options_for_request(method, route, params, idempotent)
      api_method = "#{method.to_s.upcase} #{options[:path]}"
      response = connection.request(options)

      JSON.parse(response.body)
    rescue Excon::Errors::HTTPStatusError => e
      raise HttpError.new(e.response),
        "Unexpected status #{e.response.status} calling #{api_method}: #{http_error_body(e.response.body)}"
    rescue Excon::Errors::Error, JSON::ParserError => e
      raise ApiError, "Exception #{e.class} calling #{api_method}: #{e}"
    end

    def options_for_request(method, route, params, idempotent)
      # For cleanliness, strip initial / if supplied
      route = route.sub(%r{^\/}, '')
      path = "/nomisapi/#{route}"

      {
        method: method,
        path: path,
        expects: [200],
        idempotent: idempotent,
        retry_limit: 2,
        headers: {
          'Accept' => 'application/json',
          'Authorization' => auth_header,
          'X-Request-Id' => RequestStore.store[:request_id]
        }
      }.deep_merge(params_options(method, params))
    end

    # Returns excon options which put params in either the query string or body.
    def params_options(method, params)
      return {} if params.empty?

      { query: params } if %i[get delete].includes? method
    end

    def auth_header
      return unless client_token && client_key

      token = auth_token(client_token, client_key)
      "Bearer #{token}"
    end

    def auth_token(client_token, client_key)
      payload = {
        iat: Time.now.utc.to_i,
        token: client_token
      }
      JWT.encode(payload, client_key, 'ES256')
    end

    def http_error_body(original_body)
      # API errors should be returned as JSON, but there are many scenarios
      # where this may not be the case.
      JSON.parse(original_body)
    rescue JSON::ParserError
      # Present non-JSON bodies truncated (e.g. this could be HTML)
      "(invalid-JSON) #{body[0, 80]}"
    end
  end
end
