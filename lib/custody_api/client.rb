# frozen_string_literal: true

require 'faraday_middleware'

module CustodyApi
  class Client
    TIMEOUT = 2 # seconds

    def initialize(host: TEST_HOST, token: TEST_TOKEN)
      @host = host
      @token = token
    end
    attr_reader :host, :token

    TEST_HOST = 'http://localhost:8080'
    TEST_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbnRlcm5hbFVzZXIiOmZhbHNlLCJzY29wZSI6WyJyZXBvcnRpbmciXSwiZXhwIjoxODU1MTAzNTYxLCJhdXRob3JpdGllcyI6WyJST0xFX1JFUE9SVElORyJdLCJqdGkiOiJkYWJjMDc3ZC1mYmE4LTQzZGUtOTkyZC00ZjBiYTVmZDY5OTIiLCJjbGllbnRfaWQiOiJhcGlyZXBvcnRpbmcifQ.YuyZhli_xrapAbPs1pgCzAQDChJKWmSR3RPZ7Eyi1ZiZ78eQOHrvOtd_cPCbN6WkJXfP4gI2RBT6EiG1l4gjbNTRT2UmSb94TmM8Vww3Sk9yDa5J1uh7kFGEYpKQC9Isot0qtdeYZNi4GYx-6wi9ARRHRbvPyRHBgIHb3WSe4P4N0AfeeHC2tenzeru_V4m4fPzr1dJKRlTzSHrxw48E0lxPydIkHUd_qQTxdy-PQQLyxMI9syKsy1q1CO9rdXxIO5_OlB2Vgcv3PBzvDkI-EaFSS_-hX14EBJB4-dLVuo3V87RHbW0FBDTlcx9yF3lQeQnCoXPML-cbkQifLVjARA'

    def get(path, params={})
      faraday.get path, params
    end

    private

    def faraday
      @faraday ||= begin
        conn = Faraday.new(url: host)
        conn.response :json, content_type: /\bjson$/
        conn.authorization :Bearer, token
        conn.headers['Accept'] = 'application/json' 
        conn
      end
    end
  end
end
