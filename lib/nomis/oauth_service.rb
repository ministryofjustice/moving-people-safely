# frozen_string_literal: true

module Nomis
  class OauthService
    include Singleton

    class << self
      delegate :valid_token, to: :instance
    end

    def valid_token
      set_new_token if token.expired?
      token
    end

  private

    def set_new_token
      @token = fetch_token
    end

    def token
      @token ||= fetch_token
    end

    def fetch_token
      host = Rails.application.secrets[:nomis_api][:oauth_host]
      oauth_client = Nomis::OauthClient.new(host)

      route = '/auth/oauth/token?grant_type=client_credentials'
      response = oauth_client.post(route)
      OauthToken.from_json(response)
    end
  end
end
