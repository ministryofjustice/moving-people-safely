# frozen_string_literal: true

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
    alias data to_h

    private

    attr_reader :hash
  end
end
