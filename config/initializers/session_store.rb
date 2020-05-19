# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store,
  key: '_moving-people-safely_session',
  expire_after: 15.minutes, # This is after specified time of inactivity
  secure: Rails.env.production? && !ENV.fetch('DEV_DOCKER_INSTANCE', false)
