require 'faraday'
require 'json'
require 'nomis/middlewares/parse_json'
require 'nomis/models/details'
require 'nomis/error'

module Nomis
  class Client
    def initialize(endpoint:)
      @endpoint = endpoint
    end

    def offender_details(prison_number:)
      res = get(path: '/offender_details', prison_number: prison_number)
      res[:offenderdetails].map { |h| Details.new(h) }
    end

    private

    def get(path:, prison_number:)
      connection.get(path, noms_id: prison_number).body
    rescue Faraday::Error::TimeoutError => error
      raise Nomis::Error::RequestTimeout, error
    rescue JSON::ParserError => error
      raise Nomis::Error::InvalidResponse, error
    end

    def connection
      @connection ||= Faraday.new(@endpoint) do |c|
        c.use ParseJson
        c.use Faraday::Adapter::NetHttp
      end
    end
  end
end
