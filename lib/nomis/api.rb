# frozen_string_literal: true

module Nomis
  Error = Class.new(StandardError)
  DisabledError = Class.new(Error)

  class Api
    include Singleton

    class << self
      attr_accessor :configuration

      def enabled?
        configuration.api_host != nil
      end

      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    end

    def initialize
      raise DisabledError, 'Nomis API is disabled' unless self.class.enabled?

      @pool = ConnectionPool.new(size: configuration.pool_size, timeout: 1) do
        Nomis::Client.new(configuration.api_host, configuration.client_id, configuration.client_secret)
      end
    end

    def configuration
      self.class.configuration
    end

    def get(path, options = {})
      pool.with { |client| client.get(path, options) }
    end

    private

    attr_reader :pool
  end
end
