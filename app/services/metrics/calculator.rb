module Metrics
  class Calculator
    MINUTES_SAVED_WITH_REUSE_OF_PER = 23.minutes
    MINUTES_SAVED_FILLING_A_PER_FOR_THE_FIRST_TIME = 2.5.minutes

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
      # 3600 is the number of seconds in an hour
      hours = (total_reused_escorts * MINUTES_SAVED_WITH_REUSE_OF_PER) / 3600
      hours += (total_unique_detainees_escorted * MINUTES_SAVED_FILLING_A_PER_FOR_THE_FIRST_TIME) / 3600
      [{ hours_saved: hours.round }]
    end

    def percentage_saved
      minutes_saved_with_eper = total_reused_escorts * 23.minutes + total_unique_detainees_escorted * 2.5.minutes
      minutes_to_complete_per_manually = total_issued_escorts * 28.minutes
      percentage = minutes_saved_with_eper / minutes_to_complete_per_manually * 100
      [{ percentage_saved: percentage.round }]
    end

    def hours_saved_last_3_months
      last_three_months.map do |month_year|
        {
          month_name: Date::MONTHNAMES[month_year[:month]],
          hours_saved: hours_saved_in_month(month_year[:month], month_year[:year]).round
        }
      end
    end

    private

    attr_reader :logger

    def total_initiated_escorts
      @tinitiated ||= Escort.unscoped.count
    end

    def total_reused_escorts
      total_issued_escorts - total_unique_detainees_escorted
    end

    def total_issued_escorts
      @tissued ||= Escort.issued.count
    end

    def total_unique_detainees_escorted
      @tuniq_detainees ||= Escort.issued.select('distinct(prison_number)').count
    end

    def total_escorts_auto_deleted
      @tautodel ||= Escort.unscoped.where.not(deleted_at: nil).count
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

    def hours_saved_in_month(month, year)
      hours = (Escort.issued.in_month(month, year).count * 23.minutes) / 3600
      hours + (Escort.issued.in_month(month, year).select('distinct(prison_number)').count * 2.5.minutes) / 3600
    end

    def last_three_months
      2.downto(0).map do |i|
        date = (Date.current - i.month)
        { month: date.month, year: date.year }
      end
    end
  end
end
