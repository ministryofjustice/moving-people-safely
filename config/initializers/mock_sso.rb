if Rails.env.development? && ENV['MOCK_SSO'] == 'true'
  OmniAuth.config.test_mode = true

  begin
    server_options = Rails::Server.new.options
    base_url = "#{server_options[:Host]}:#{server_options[:Port]}"
  rescue
    base_url = 'localhost:3000'
  end

  OmniAuth.config.add_mock(
    :mojsso,
    {
      'provider': 'mojsso',
      'uid': '1234',
      'info': {
        "id": 1,
        "email": "example@some.prison.com",
        "first_name": "Joe",
        "last_name": "Bloggs",
        "permissions": [{"organisation"=>"digital.noms.moj"}],
        "links": {
          "profile": "http://#{base_url}/profile",
          "logout": "http://#{base_url}/session/new"
        }
      },
      'credentials': {
        'token': 'mock-token',
        'secret': 'mock-secret'
      }
    }
  )
end
