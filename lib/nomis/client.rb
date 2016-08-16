require 'faraday'
require 'json'
require 'nomis/middlewares/parse_json'
require 'nomis/models/details'
require 'nomis/error'

module Nomis
  class Client
    def offender_details(prison_number:)
      res = get(path: '/offender_details', prison_number: prison_number)
      res[:offenderdetails].map { |h| Details.new(h) }
    end

    private

    def get(path:, prison_number:)
      connection.get(path, noms_id: prison_number).body
    rescue Faraday::Error::TimeoutError => error
      raise Nomis::Error::RequestTimeout, error
    end

    ENDPOINT = 'https://serene-chamber-74280.herokuapp.com/'

    def connection
      @connection ||= Faraday.new(ENDPOINT) do |c|
        c.use ParseJson
        c.use Faraday::Adapter::NetHttp
      end
    end
  end
end
