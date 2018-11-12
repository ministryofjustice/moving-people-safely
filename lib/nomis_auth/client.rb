# frozen_string_literal: true

require 'faraday_middleware'
require 'nomis_auth/token'

module NomisAuth
  class Client
    def initialize(host: TEST_HOST, client_id:, client_secret:)
      @host = host
      @client_id = client_id
      @client_secret = client_secret
    end
    attr_reader :host, :client_id, :client_secret

    TEST_HOST = 'http://localhost:9090'

    def token
      resp = faraday.post 'oauth/token',
        grant_type: 'client_credentials'

      return unless resp.success?

      Token.from_json resp.body
    end

    private

    def faraday
      @faraday ||= begin
        conn = Faraday.new(url: host)
        conn.response :json, content_type: /\bjson$/
        conn.basic_auth client_id, client_secret
        conn.headers['Accept'] = 'application/json'
        conn
      end
    end
  end
end
