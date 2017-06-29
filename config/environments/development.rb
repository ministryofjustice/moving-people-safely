Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # no json logging in development plz
  config.logstasher.enabled = false

  if ENV['MOCK_AWS_S3'] == 'true'
    paperclip_configurations  = {
      storage: :filesystem,
      path: ':rails_root/tmp:url',
      url: '/:class/:attachment/:id/:filename'
    }
  else
    aws_secrets = Rails.application.secrets[:aws]
    paperclip_configurations = {
      storage: :s3,
      s3_credentials: {
        bucket: aws_secrets['s3_bucket_name'],
        access_key_id: aws_secrets['access_key_id'],
        secret_access_key: aws_secrets['secret_access_key'],
        s3_region: 'eu-west-1'
      },
      path: '/:class/:attachment/:id/:filename',
      url: ':s3_domain_url'
    }
  end
  config.paperclip_defaults = paperclip_configurations
end
