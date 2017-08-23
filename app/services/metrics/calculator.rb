module Metrics
  class Calculator
    def initialize(options = {})
      @logger = options.fetch(:logger, Rails.logger)
    end

    def total_escorts
      [
        {
          total_initiated_escorts: total_initiated_escorts,
          total_issued_escorts: total_issued_escorts,
          total_unique_detainees_escorted: total_unique_detainees_escorted,
          total_reused_escorts: total_reused_escorts,
          total_unused_escorts: total_escorts_auto_deleted
        }
      ]
    end

    def escorts_by_date
      all_escorts_in_last_number_of_days(30)
    end

    def hours_saved
      hours = (total_reused_escorts * 23.minutes) / (60 * 60)

      [{ hours_saved: hours }]
    end

    private

    attr_reader :logger

    def at
      Escort.arel_table
    end

    def total_initiated_escorts
      @tinitiated ||= Escort.unscoped.count
    end

    def total_reused_escorts
      total_issued_escorts - total_unique_detainees_escorted
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

    def all_escorts_in_last_number_of_days(num_days = 30)
      @last_num_dats ||= Escort.connection.execute(%{
        SELECT
          COALESCE(subquery1.date, subquery2.date) AS date,
          COALESCE(subquery1.total, 0) as total_issued,
          COALESCE(subquery2.total, 0) AS total_not_issued
        FROM
          (#{issued_in_last_number_of_days(num_days)}) subquery1
          FULL OUTER JOIN
          (#{not_issued_in_last_number_of_days(num_days)}) subquery2
          ON (subquery1.date = subquery2.date)
        ORDER BY date;
      })
    end

    def issued_in_last_number_of_days(num_days)
      Escort.unscoped.issued.select('count(*) AS total, moves.date').in_last_days(num_days).group(:date).to_sql
    end

    def not_issued_in_last_number_of_days(num_days)
      Escort.unscoped.active.select('count(*) AS total, moves.date').in_last_days(num_days).group(:date).to_sql
    end
  end
end
