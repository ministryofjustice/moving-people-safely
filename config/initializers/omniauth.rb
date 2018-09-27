require 'mojsso'

module MovingPeopleSafely
  class Application < Rails::Application
    config.x.moj_sso_url = ENV.fetch('MOJSSO_URL', 'http://localhost:5000')
  end
end

def initialize_omniauth
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :mojsso,
      ENV.fetch('MOJSSO_ID'),
      ENV.fetch('MOJSSO_SECRET'),
      client_options: { site: Rails.application.config.x.moj_sso_url }
    )
  end
  OmniAuth.config.on_failure = SessionsController.action(:new)
  OmniAuth.config.logger = Rails.logger
end

initialize_omniauth unless ENV.fetch('SKIP_OPTIONAL_INITIALIZERS', false)
