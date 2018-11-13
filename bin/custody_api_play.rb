require 'nomis_auth/client'

auth = NomisAuth::Client.new(
  host: ENV.fetch("NOMIS_AUTH_HOST"),
  client_id: ENV.fetch("NOMIS_AUTH_CLIENT_ID"),
  client_secret: ENV.fetch("NOMIS_AUTH_CLIENT_SECRET")
)

token = auth.token

puts "\n\ngot token:\n"
puts token

require 'custody_api/client'

api = CustodyApi::Client.new(
  host: ENV.fetch("CUSTODY_API_HOST"),
  token: token
)

resp = api.get('api/events')
unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body
puts "\n\nevents:\n"
puts "count: #{json.length}"
puts "first: #{json.first}"

MOVEMENT_EVENT_TYPES = [
  "EXTERNAL_MOVEMENT_RECORD-INSERTED",
  "EXTERNAL_MOVEMENT_RECORD-DELETED",
  "EXTERNAL_MOVEMENT_RECORD-UPDATED",
  "OFFENDER_MOVEMENT-DISCHARGE",
  "OFFENDER_MOVEMENT-RECEPTION"
]

date = Date.new(2017,7,24)

resp = api.get('api/events',
  from: date.to_time.utc.iso8601,
  type: MOVEMENT_EVENT_TYPES
)

unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body
puts "\n\nevents:\n"
puts "count: #{json.length}"
puts "first: #{json.first}"

resp = api.get("api/offenders/offenderId/1393147/movements")

unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body

puts "\n\nmovements:\n"
puts "count: #{json.length}"
puts "first: #{json.first}"
