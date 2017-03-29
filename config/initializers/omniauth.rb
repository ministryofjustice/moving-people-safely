require 'mojsso'

def initialize_omniauth
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :mojsso,
      ENV.fetch('MOJSSO_ID'),
      ENV.fetch('MOJSSO_SECRET'),
      client_options: { site: ENV.fetch('MOJSSO_URL', 'http://localhost:5000') }
    )
  end
  OmniAuth.config.on_failure = SessionsController.action(:new)
end

initialize_omniauth unless ENV.fetch('SKIP_OPTIONAL_INITIALIZERS', false)
