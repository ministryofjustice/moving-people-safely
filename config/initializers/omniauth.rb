require 'mojsso'

# NOTE: In a real application you'd store configuration in env variables

# Staging SSO config
app_id = ENV.fetch('MOJSSO_ID', '5f433ad37970b91598f294dcdcc2ccabdb20f2db74cf475c6cff6ac7dfc16469')
app_secret = ENV.fetch('MOJSSO_SECRET', 'a09502ec1d7f2c1f61477fde37ba2c0eeac1b05fe13e905da88aea97315af04d')
sso_url = ENV.fetch('MOJSSO_URL', 'https://www.signon.dsd.io/')

# Localhost SSO config
# app_id = ENV.fetch('MOJSSO_ID', 'eaaf4f6f3f683c4fa79fabe53d448b466225ab7f6612c3379b59c4365860add7')
# app_secret = ENV.fetch('MOJSSO_SECRET', 'fe1e2ec9ef95ae2e150753eb3b61c6620a2ab691376e29e7c5cb26dbed5417ea')
# sso_url = ENV.fetch('MOJSSO_URL', 'http://localhost:5000')

unless app_id && app_secret && sso_url
  STDOUT.puts '[WARN] MOJSSO_ID/MOJSSO_SECRET/MOJSSO_URL not configured'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mojsso, app_id, app_secret, client_options: { site: sso_url }
end
