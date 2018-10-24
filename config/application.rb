require_relative 'boot'

require 'rails/all'

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
    config.app_title = 'Moving people safely'
    config.proposition_title = 'Moving people safely'
    config.phase = 'alpha'
    config.product_type = 'service'
    config.feedback_url = 'https://www.surveymonkey.co.uk/r/eperfeedback'
    config.assets.paths << Rails.root.join('node_modules')
    config.assets.paths << Rails.root.join('app', 'assets', 'flash')
    config.time_zone = 'London'

    require "#{config.root}/app/form_builders/errors_helper"
    require "#{config.root}/app/form_builders/mps_form_builder"
    ActionView::Base.default_form_builder = MpsFormBuilder
  end
end
