require 'offenders_api'

def Rails.offenders_api_client
  @_offenders_api_client ||= OffendersApi::Client.new({
    client_id: application.secrets.offenders_api.fetch('client_id'),
    client_secret: application.secrets.offenders_api.fetch('client_secret'),
    base_url: application.secrets.offenders_api.fetch('base_url')
  })
end
