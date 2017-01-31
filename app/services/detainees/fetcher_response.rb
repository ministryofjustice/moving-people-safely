module Detainees
  class FetcherResponse
    attr_reader :error

    def initialize(hash, options = {})
      @hash = hash
      @error = options[:error]
    end

    def to_h
      hash
    end

    private

    attr_reader :hash
  end
end
