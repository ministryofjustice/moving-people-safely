# frozen_string_literal: true

require 'csv'

module CompareAutoAlerts
  class CsvWriter
    def self.write(comparisons)
      CSV.generate do |csv|
        csv << %w[escort_id prison_number moved_at to_type attribute human auto outcome days_since_moved]

        comparisons.each do |prison_number, data|
          data[:comparison].each do |attr, details|
            csv << [data[:id], prison_number, data[:moved_at], data[:to_type],
                    attr, details[:human], details[:auto], details[:outcome],
                    data[:days_since_moved]]
          end
        end
      end
    end
  end
end
