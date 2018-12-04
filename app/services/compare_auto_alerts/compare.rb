# frozen_string_literal: true

# In terminal log into prod machine and capture the output to a file:
# local# ssh mps-prod | tee output.out
# prod# sudo docker ps
# prod# sudo docker exec -it mps-app bash
# container# bundle exec rails c production
# Run whatever query on Escorts you want to get an array of IDs:
# console# ids = Escort.issued.joins(:risk).where("risks.controlled_unlock_required = 'no'").pluck(:id)
# => <an-array-of-ids>
#
# Run whichever comparison method you require passing in the IDs:
# console# CompareAutoAlerts::Compare.as_hash(ids) # => a hash
# console# CompareAutoAlerts::Compare.as_csv(ids)  # => CSV output
# When all is done exit back out to local machine and you have the output file
module CompareAutoAlerts
  class Compare
    RISK_CACHE = Rails.root.join('tmp', 'risk_cache.json').freeze
    PAUSE_BETWEEN_API_CALLS = 3

    def self.as_hash(ids, pause: PAUSE_BETWEEN_API_CALLS, quiet: false)
      cached_risks = RISK_CACHE.exist? ? JSON.parse(RISK_CACHE.read) : {}

      compare_escorts(ids, cached_risks, pause, quiet: quiet).tap do
        RISK_CACHE.open('w') { |f| f.write(cached_risks.to_json) }
      end
    end

    def self.as_csv(ids, pause: PAUSE_BETWEEN_API_CALLS)
      STDOUT.puts CsvWriter.write(as_hash(ids, pause: pause))
    end

    def self.escorts(ids)
      Escort.find(ids)
    end

    def self.compare_escorts(ids, cached_risks, pause, quiet: false)
      escorts(ids).each_with_object({}).with_index do |(escort, comparisons), i|
        report(escort, i + 1, ids.size) unless quiet
        cached_risks[escort.prison_number] ||= fetch_mapped_risks(escort)

        comparisons[escort.prison_number] = escort_details(
          escort, cached_risks[escort.prison_number]
        )

        sleep pause
      end
    end

    def self.report(escort, count, tot)
      STDERR.puts "Comparing escort (#{count}/#{tot}): #{escort.id} " \
        "#{escort.prison_number}"
    end

    def self.fetch_mapped_risks(escort)
      Detainees::RiskFetcher.new(
        escort.prison_number, move_date: escort.move.date
      ).call.to_h
    end

    def self.escort_details(escort, mapped_risks)
      {
        id: escort.id,
        moved_at: escort.move.date,
        to_type: escort.move.to_type,
        days_since_moved: days_since_moved(escort),
        comparison: comparison(escort, mapped_risks)
      }
    end

    def self.days_since_moved(escort)
      return nil unless escort.move

      (Date.today - escort.move.date).to_i
    end

    def self.comparison(escort, mapped_risks)
      mapped_risks.each_with_object({}) do |pair, comp|
        attr = pair.first
        val = pair.last
        human = escort.risk.send(attr)
        comp[attr.to_sym] = { human: human, auto: val, outcome: outcome(human, val) }
      end
    end

    def self.outcome(human, auto)
      return 'MATCH' if human == auto

      truthy?(human) && !truthy?(auto) ? 'FALSE_NEGATIVE' : 'DIFFER'
    end

    def self.truthy?(expr)
      return expr if [TrueClass, FalseClass].include?(expr.class)

      /yes|true/i =~ expr
    end
  end
end
