require 'nomis'

read_key = lambda { |string|
  return unless string.present?
  begin
    der = Base64.decode64(string)
    OpenSSL::PKey::EC.new(der)
  rescue OpenSSL::PKey::ECError => e
    Rails.logger.warn "Invalid ECDSA key: #{e}"
    nil
  rescue ArgumentError => e
    Rails.logger.warn "Invalid ECDSA key: #{e}"
    nil
  end
}

nomis_secrets = Rails.application.secrets[:nomis_api]

Nomis::Api.configure do |config|
  config.api_host  = nomis_secrets['host']
  config.api_token = nomis_secrets['token']
  config.api_key   = read_key.call(nomis_secrets['key'])
  config.pool_size = 5
end
