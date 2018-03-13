require 'csv'

module CompareAutoAlerts
  class CsvWriter
    def self.write(comparisons)
      CSV.generate do |csv|
        csv << %w[prison_number created_at to_type attribute human auto outcome]

        comparisons.each do |prison_number, data|
          data[:comparison].each do |attr, details|
            csv << [prison_number,
                    data[:created_at],
                    data[:to_type],
                    attr,
                    details[:human],
                    details[:auto],
                    details[:outcome]]
          end
        end
      end
    end
  end
end
