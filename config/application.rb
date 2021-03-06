require_relative 'boot'

require 'rails/all'
require 'active_storage/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MovingPeopleSafely
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.feedback_url = 'https://www.surveymonkey.co.uk/r/eperfeedback'
    config.time_zone = 'London'

    config.exceptions_app = routes

    require "#{config.root}/app/form_builders/govuk_form_builder"
    ActionView::Base.default_form_builder = GovukFormBuilder
  end
end
