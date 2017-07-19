require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MovingPeopleSafely
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.app_title = 'Moving people safely'
    config.proposition_title = 'Moving people safely'
    config.phase = 'alpha'
    config.product_type = 'service'
    config.feedback_url = ''
    config.assets.paths << Rails.root.join('vendor', 'bower')
    config.autoload_paths << "#{Rails.root}/app/models/sections"
    config.time_zone = 'London'

    require "#{config.root}/app/form_builders/govuk_elements_errors_helper"
    require "#{config.root}/app/form_builders/mps_form_builder"
    ActionView::Base.default_form_builder = MpsFormBuilder
  end
end
