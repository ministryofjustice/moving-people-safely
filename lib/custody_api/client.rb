# frozen_string_literal: true

require 'faraday_middleware'
require 'nomis_auth/token'

module CustodyApi
  #
  # A client for interacting with the Custody API
  # 
  # First of all a client_credentials token needs to be created
  # See NomisAuth::Client
  # 
  #   custody = CustodyApi::Client.new
  #   resp = custody.get 'api/offenders'
  #   fail unless resp.success?
  #
  #   offenders = resp.body['_embedded']['offenders']
  # 
  class Client
    def initialize(host: TEST_HOST, token: TEST_TOKEN)
      @host = host
      @token = token
    end
    attr_reader :host, :token

    TEST_HOST = 'http://localhost:8080'
    TEST_TOKEN = NomisAuth::Token.new(
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbnRlcm5hbFVzZXIiOmZhbHNlLCJzY29wZSI6WyJyZXBvcnRpbmciXSwiZXhwIjoxODU1MTAzNTYxLCJhdXRob3JpdGllcyI6WyJST0xFX1JFUE9SVElORyJdLCJqdGkiOiJkYWJjMDc3ZC1mYmE4LTQzZGUtOTkyZC00ZjBiYTVmZDY5OTIiLCJjbGllbnRfaWQiOiJhcGlyZXBvcnRpbmcifQ.YuyZhli_xrapAbPs1pgCzAQDChJKWmSR3RPZ7Eyi1ZiZ78eQOHrvOtd_cPCbN6WkJXfP4gI2RBT6EiG1l4gjbNTRT2UmSb94TmM8Vww3Sk9yDa5J1uh7kFGEYpKQC9Isot0qtdeYZNi4GYx-6wi9ARRHRbvPyRHBgIHb3WSe4P4N0AfeeHC2tenzeru_V4m4fPzr1dJKRlTzSHrxw48E0lxPydIkHUd_qQTxdy-PQQLyxMI9syKsy1q1CO9rdXxIO5_OlB2Vgcv3PBzvDkI-EaFSS_-hX14EBJB4-dLVuo3V87RHbW0FBDTlcx9yF3lQeQnCoXPML-cbkQifLVjARA',
      nil
    )

    def get(path, params = {})
      faraday.get path, params
    end

    private

    def faraday
      @faraday ||= begin
        conn = Faraday.new(url: host)
        conn.response :json, content_type: /\bjson$/
        conn.authorization :Bearer, token.access_token
        conn.headers['Accept'] = 'application/json'

        # XXX: this allows `type: [:an, :array]` to work
        conn.options[:params_encoder] = Faraday::FlatParamsEncoder
        conn
      end
    end
  end
end
