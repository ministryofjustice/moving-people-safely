url = Rails.application.secrets[:zendesk_api][:url]
username = Rails.application.secrets[:zendesk_api][:username]
token = Rails.application.secrets[:zendesk_api][:token]

if url && username && token
  Rails.configuration.zendesk_client = ZendeskAPI::Client.new do |config|
    config.url = url
    config.username = username
    config.token = token
    config.retry = true
  end
else
  # (Rails logger is not initialized yet)
  STDOUT.puts '[WARN] Zendesk is not configured'
end
