require 'nomis/refinements/downcased_hash_keys'

module Nomis
  class ParseJson < Faraday::Response::Middleware
    using DowncasedHashKeys

    def on_complete(response)
      response.body = JSON.parse(response.body, symbolize_names: true).downcase_keys
    end
  end
end
