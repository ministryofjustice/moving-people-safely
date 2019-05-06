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

def debug(resp, label, show: :all)
  unless resp.success?
    fail "problem getting from api #{resp.body}"
  end

  json = resp.body
  puts "\n\n#{label}:\n"
  puts "count: #{json.length}"

  if show == :all
    puts "all:"
    puts JSON.pretty_generate(json)
  else
    puts "first:"
    puts JSON.pretty_generate(json.first)
  end
end

def debug_all(*args)
  debug(*args)
end

def debug_first(*args)
  debug(*args, show: :first)
end

# alerts
resp = api.get("api/offenders/offenderId/#{offender_id}/alerts")
debug_all(resp, :alerts)

# events
resp = api.get("api/offenders/offenderId/#{offender_id}/events")
debug_first(resp, :events)

MOVEMENT_EVENT_TYPES = [
  "EXTERNAL_MOVEMENT_RECORD-INSERTED",
  "EXTERNAL_MOVEMENT_RECORD-DELETED",
  "EXTERNAL_MOVEMENT_RECORD-UPDATED",
  "OFFENDER_MOVEMENT-DISCHARGE",
  "OFFENDER_MOVEMENT-RECEPTION"
]

date = Date.new(2014,8, 11)

resp = api.get("api/offenders/offenderId/#{offender_id}/events",
  from: date.to_time.utc.iso8601,
  type: MOVEMENT_EVENT_TYPES
)
debug_first(resp, :movement_events)

resp = api.get("api/offenders/offenderId/#{offender_id}/movements")
debug_all(resp, :movements)

resp = api.get("api/offenders/offenderId/#{offender_id}/courtEvents")
debug_all(resp, :court_events)

resp = api.get("api/offenders/offenderId/#{offender_id}/diaryDetails")
debug_all(resp, :diary_details)

resp = api.get("api/offenders/offenderId/#{offender_id}/individualSchedules")
debug_all(resp, :individual_schedules)
