# frozen_string_literal: true

module Nomis
  class OauthClient
    def initialize(host)
      @host = host
      @connection = Faraday.new
    end

    def post(route)
      response = @connection.send(:post) { |req|
        url = URI.join(@host, route).to_s
        req.url(url)
        req.headers['Authorization'] = authorisation
      }

      JSON.parse(response.body)
    end

  private

    # rubocop:disable Layout/LineLength
    def authorisation
      'Basic ' + Base64.urlsafe_encode64(
        "#{Rails.application.secrets[:nomis_api][:client_id]}:#{Rails.application.secrets[:nomis_api][:client_secret]}"
      )
    end
    # rubocop:enable Layout/LineLength
  end
end