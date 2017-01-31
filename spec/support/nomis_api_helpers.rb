module NomisApiHelpers
  def stub_nomis_api_request(request_type, path, options = {})
    base_uri = "#{Nomis::Api.configuration.api_host}/nomisapi"
    stub_request(:get, "#{base_uri}#{path}").to_return({
      body: options.fetch(:body, {}.to_json),
      status: options.fetch(:status, 200)
    })
  end
end
