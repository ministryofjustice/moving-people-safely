module OauthHelper
  def sign_in(_user, options = { sso: { info: { permissions: [{'organisation' => 'digital.noms.moj'}]}}})
    configure_mock(options.fetch(:sso, {}))
    get "/auth/mojsso/callback"
  end

  def configure_mock(sso_config = {})
    OmniAuth.config.add_mock(:mojsso, OAUTH_HASH.deep_merge(sso_config))
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
        "logout": "http://some-sso.biz/users/sign_out"
      }
    },
    'credentials': {
      'token': 'mock-token',
      'secret': 'mock-secret',
      'expires': true,
      'expires_at': Time.now.to_i + 3600
    }
  }.freeze
end
