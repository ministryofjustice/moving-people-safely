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

noms_id = 'G0952GH'

resp = api.get("api/offenders/nomsId/#{noms_id}")
unless resp.success?
  fail "problem getting from api #{resp.body}"
end
json = resp.body
puts "\n\noffender:\n"
puts "json:"
puts JSON.pretty_generate(json)

offender_id = json['offenderId']
first_name = json['firstName']
surname = json['surname']
date_of_birth = json['dateOfBirth']
gender = json['gender']['description']

# alerts

resp = api.get("api/offenders/offenderId/#{offender_id}/alerts")
unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body
puts "\n\nalerts:\n"
puts "count: #{json.length}"
puts "all:"
puts JSON.pretty_generate(json)

# events

resp = api.get("api/offenders/offenderId/#{offender_id}/events")
unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body
puts "\n\nevents:\n"
puts "count: #{json.length}"
puts "first:"
puts JSON.pretty_generate(json.first)

MOVEMENT_EVENT_TYPES = [
  "EXTERNAL_MOVEMENT_RECORD-INSERTED",
  "EXTERNAL_MOVEMENT_RECORD-DELETED",
  "EXTERNAL_MOVEMENT_RECORD-UPDATED",
  "OFFENDER_MOVEMENT-DISCHARGE",
  "OFFENDER_MOVEMENT-RECEPTION"
]

date = Date.new(2017,7,24)

resp = api.get("api/offenders/offenderId/#{offender_id}/events",
  from: date.to_time.utc.iso8601,
  type: MOVEMENT_EVENT_TYPES
)

unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body
puts "\n\nevents:\n"
puts "count: #{json.length}"
puts "first:"
pp json.first

resp = api.get("api/offenders/offenderId/#{offender_id}/movements")

unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body

puts "\n\nmovements:\n"
puts "count: #{json.length}"
puts JSON.pretty_generate(json)


resp = api.get("api/offenders/offenderId/#{offender_id}/courtEvents")

unless resp.success?
  fail "problem getting from api #{resp.body}"
end

json = resp.body

puts "\n\ncourt events:\n"
puts "count: #{json.length}"
puts JSON.pretty_generate(json)