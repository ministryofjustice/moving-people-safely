module Metrics
  class Calculator
    TIME_SAVED_WITH_REUSE_OF_PER = 15.minutes
    TIME_SAVED_FILLING_A_PER_FOR_THE_FIRST_TIME = 2.5.minutes
    TIME_TAKEN_TO_COMPLETE_A_PER_MANUALLY = 28.minutes

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
      hours = (time_saved_with_reuse_of_escorts + time_saved_for_first_time_escorts) / 3600
      [{ hours_saved: hours.round }]
    end

    def percentage_saved
      time_saved_with_eper = time_saved_with_reuse_of_escorts + time_saved_for_first_time_escorts
      time_to_complete_pers_manually = total_issued_escorts * TIME_TAKEN_TO_COMPLETE_A_PER_MANUALLY
      percentage = time_saved_with_eper / time_to_complete_pers_manually * 100
      [{ percentage_saved: percentage.round }]
    end

    def hours_saved_last_3_months
      last_three_months.map do |month_year|
        {
          month_name: "#{month_year[:year]}-#{month_year[:month]}",
          hours_saved: hours_saved_in_month(month_year[:month], month_year[:year])
        }
      end
    end

    private

    attr_reader :logger

    def total_initiated_escorts
      @_total_initiated_escorts ||= Escort.unscoped.count
    end

    def total_issued_escorts
      @_total_issued_escorts ||= Escort.issued.count
    end

    def total_unique_detainees_escorted
      @_total_unique_detainees_escorted ||= Escort.issued.distinct.count(:prison_number)
    end

    def total_escorts_auto_deleted
      @_total_escorts_auto_deleted ||= Escort.unscoped.where.not(deleted_at: nil).count
    end

    def total_reused_escorts
      total_issued_escorts - total_unique_detainees_escorted
    end

    def time_saved_with_reuse_of_escorts
      total_reused_escorts * TIME_SAVED_WITH_REUSE_OF_PER
    end

    def time_saved_for_first_time_escorts
      total_unique_detainees_escorted * TIME_SAVED_FILLING_A_PER_FOR_THE_FIRST_TIME
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
      Escort.unscoped.issued.select('count(*) AS total, date').in_last_days(num_days).group(:date).to_sql
    end

    def not_issued_in_last_number_of_days(num_days)
      Escort.unscoped.active.select('count(*) AS total, date').in_last_days(num_days).group(:date).to_sql
    end

    def hours_saved_in_month(month, year)
      total_issued_escorts_in_month = Escort.issued.in_month(month, year).count
      total_unique_detainees_escorted_in_month = Escort.issued.in_month(month, year).distinct.count(:prison_number)
      total_reused_escorts_in_month = total_issued_escorts_in_month - total_unique_detainees_escorted_in_month

      time_saved_in_month = total_reused_escorts_in_month * TIME_SAVED_WITH_REUSE_OF_PER +
                            total_unique_detainees_escorted_in_month * TIME_SAVED_FILLING_A_PER_FOR_THE_FIRST_TIME

      (time_saved_in_month / 3600).round
    end

    def last_three_months
      2.downto(0).map do |i|
        date = (Date.current - i.month)
        { month: date.month, year: date.year }
      end
    end
  end
end
