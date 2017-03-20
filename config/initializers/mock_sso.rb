if Rails.env.development? && ENV['MOCK_SSO']
  OmniAuth.config.test_mode = true
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
    }
  )
end
