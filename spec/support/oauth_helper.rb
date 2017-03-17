module OauthHelper
  def sign_in(*)
    configure_mock
    get "/auth/mojsso/callback"
  end

  def configure_mock
    OmniAuth.config.add_mock(:mojsso, OAUTH_HASH)
  end

  module_function :sign_in, :configure_mock

  OAUTH_HASH = {
    'provider': 'mojsso',
    'uid': '1234',
    'info': {
      "id": 1,
      "email": "example@some.prison.com",
      "first_name": "Joe",
      "last_name": "Bloggs",
      "permissions": [],
      "links": {
        "profile": "https://some-sso.biz/profile",
        "logout": "https://some-sso.biz/users/sign_out"
      }
    },
    'credentials': {
      'token': 'mock-token',
      'secret': 'mock-secret'
    }
  }.freeze
end
