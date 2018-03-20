module CompareAutoAlerts
  class Compare
    RISK_CACHE = 'risk_cache.json'.freeze

    def initialize(limit: ENV.fetch('LIMIT', 200), offset: ENV.fetch('OFFSET', 0), pause: ENV.fetch('PAUSE', 3))
      @limit = limit
      @offset = offset
      @pause = pause
    end

    def call
      cached_risks = File.exist?(RISK_CACHE) ? JSON.parse(File.read(RISK_CACHE)) : {}

      compare_escorts(cached_risks).tap do
        File.open(RISK_CACHE, 'w') { |f| f.write(cached_risks.to_json) }
      end
    end

    private

    attr_reader :limit, :offset, :pause

    def escorts
      @_escorts ||= Escort.issued.offset(offset).limit(limit).order(:id)
    end

    def compare_escorts(cached_risks)
      escorts.each_with_object({}).with_index do |(escort, comparisons), i|
        report(i, escort)
        cached_risks[escort.prison_number] ||= fetch_mapped_risks(escort)
        comparisons[escort.prison_number] = escort_details(
          escort, cached_risks[escort.prison_number]
        )
        sleep pause
      end
    end

    def report(i, escort)
      @_tot ||= escorts.count
      STDERR.puts "Comparing escort (#{i + 1}/#{@_tot}): #{escort.id} " \
        "#{escort.prison_number}"
    end

    def fetch_mapped_risks(escort)
      Detainees::RiskFetcher.new(
        escort.prison_number, move_date: escort.issued_at.to_date
      ).call.to_h
    end

    def escort_details(escort, mapped_risks)
      {
        id: escort.id,
        issued_at: escort.issued_at,
        to_type: escort.move.to_type,
        age: format('%0.2f', ((Time.now - escort.issued_at) / 86_400.0)),
        comparison: comparison(escort, mapped_risks)
      }
    end

    def comparison(escort, mapped_risks)
      mapped_risks.each_with_object({}) do |pair, comp|
        attr = pair.first
        val = pair.last
        human = escort.risk.send(attr)
        comp[attr.to_sym] = { human: human, auto: val, outcome: outcome(human, val) }
      end
    end

    def outcome(human, auto)
      return 'MATCH' if human == auto
      truthy?(human) && !truthy?(auto) ? 'FALSE_NEGATIVE' : 'DIFFER'
    end

    def truthy?(expr)
      return expr if [TrueClass, FalseClass].include?(expr.class)
      /yes|true/i =~ expr
    end
  end
end
