class TrackEvents
  ENDPOINT = URI.parse('https://www.google-analytics.com/collect').freeze

  def initialize(user, escort, event, request)
    self.user            = user
    self.escort          = escort
    self.request         = request
    self.event           = event
    self.web_property_id = 'UA-37377084-64'
  end

  def call
    if Rails.env.production?
      client.post(
        path:    ENDPOINT.path,
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body:    URI.encode_www_form(payload_data)
      )
    end
  end

  private

  attr_accessor :web_property_id, :user, :escort, :event, :request

  def client
    @client ||= Excon.new(ENDPOINT.to_s, persistent: true)
  end

  def value
    case event
    when :healthcare_complete then healhcare_completion_time
    when :risks_complete then risks_completion_time
    when :detainee_complete then detainee_completion_time
    when :move_complete then move_completion_time
    end
  end

  def detainee_completion_time
    (escort.detainee.updated_at - escort.created_at).to_i * 1000
  end

  def move_completion_time
    (escort.move.updated_at - escort.detainee.updated_at).to_i * 1000
  end

  def healhcare_completion_time
    (escort.healthcare.reviewed_at - escort.healthcare.created_at).to_i * 1000
  end

  def risks_completion_time
    (escort.risk.reviewed_at - escort.risk.created_at).to_i * 1000
  end

  def ip
    request.remote_ip
  end

  def user_agent
    request.user_agent
  end

  def cid
    request.cookies['_ga'] || SecureRandom.base64
  end

  def payload_data
    {
      v: 1, uip: ip, tid: web_property_id, cid: cid, ua:  user_agent,
      t: 'timing', utc: event, utv: event, utt: value, utl: escort.id
    }
  end
end
