require 'csv'

module CompareAutoAlerts
  class CsvWriter
    def self.write(comparisons)
      CSV.generate do |csv|
        csv << %w[escort_id prison_number issued_at to_type attribute human auto outcome days_old]

        comparisons.each do |prison_number, data|
          data[:comparison].each do |attr, details|
            csv << [data[:id], prison_number, data[:issued_at], data[:to_type],
                    attr, details[:human], details[:auto], details[:outcome], data[:age]]
          end
        end
      end
    end
  end
end
