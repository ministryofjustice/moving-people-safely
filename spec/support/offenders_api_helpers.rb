module OffendersApiHelpers
  def stub_offenders_api_request(request_type, path, options = {})
    return_options = options[:return] || {}
    mocked_response = double(HTTP::Response,
                             body: return_options.fetch(:body) { {}.to_json },
                             status: return_options.fetch(:status, 200))
    allow(Rails.offenders_api_client).to receive(request_type)
      .with(path, options.fetch(:with, anything))
      .and_return(mocked_response)
  end
end
