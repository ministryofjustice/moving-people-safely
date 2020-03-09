module NomisApiHelpers
  def stub_nomis_api_request(request_type, path, options = {})
  	stub_oauth_request
    base_uri = "#{Nomis::Api.configuration.api_host}/elite2api/api/v1"
    stub_request(:get, "#{base_uri}#{path}").to_return({
      body: options.fetch(:body, {}.to_json),
      status: options.fetch(:status, 200)
    })
  end

  def stub_oauth_request
  	stub_request(:post, "#{Rails.application.secrets[:nomis_api][:oauth_host]}/auth/oauth/token?grant_type=client_credentials").to_return({
      body: {access_token: "token"}.to_json,
      status: 200
    })
  end
end
