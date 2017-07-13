module Metrics
  class Calculator
    def initialize(options = {})
      @logger = options.fetch(:logger, Rails.logger)
    end

    def call
      [
        {
          total_initiated_escorts: total_initiated_escorts,
          total_issued_escorts: total_issued_escorts,
          total_unique_detainees_escorted: total_unique_detainees_escorted,
          total_reused_escorts: total_issued_escorts - total_unique_detainees_escorted,
          total_unused_escorts: total_escorts_auto_deleted
        }
      ]
    end

    private

    attr_reader :logger

    def at
      Escort.arel_table
    end

    def total_initiated_escorts
      @tinitiated ||= Escort.unscoped.count
    end

    def total_issued_escorts
      @tissued ||= Escort.where(at[:issued_at].not_eq(nil)).count
    end

    def total_unique_detainees_escorted
      @tuniq_detainees ||= Escort.select('distinct(prison_number)').where(at[:issued_at].not_eq(nil)).count
    end

    def total_escorts_auto_deleted
      @tautodel ||= Escort.unscoped.where(at[:deleted_at].not_eq(nil)).count
    end
  end
end
