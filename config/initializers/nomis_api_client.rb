require 'nomis'

nomis_secrets = Rails.application.secrets[:nomis_api]

Nomis::Api.configure do |config|
  config.api_host        = nomis_secrets[:host]
  config.client_id       = nomis_secrets[:client_id]
  config.client_secret   = nomis_secrets[:client_secret]
  config.pool_size = 5
end
