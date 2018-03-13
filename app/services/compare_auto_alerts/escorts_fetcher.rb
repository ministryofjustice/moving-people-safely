module CompareAutoAlerts
  class EscortsFetcher
    FILE = 'compare_escorts.json'.freeze

    attr_reader :escorts

    def initialize(limit)
      @limit = limit

      if File.exist?(FILE)
        STDERR.puts "Cached escorts found. Using those. Delete #{FILE} then " \
        'run again to query the DB directly'
        @escorts = JSON.parse(File.read(FILE)).first(limit)
      else
        @escorts = Escort.joins(:move).joins(:risk).select(
          'escorts.*, moves.*, risks.*'
        ).order(
          'escorts.created_at DESC'
        ).limit(limit).as_json
      end
    end

    def compare(alerts)
      comparisons = {}

      escorts.each_with_index do |escort, i|
        STDERR.puts "Comparing #{i + 1}/#{limit}: #{escort['id']}"
        STDERR.flush

        comparisons[escort['prison_number']] = {
          created_at: escort['created_at'],
          to_type: escort['to_type'],
          comparison: comparison(alerts, escort)
        }
      end

      comparisons
    end

    private

    attr_reader :limit

    def comparison(alerts, escort)
      escort_alerts = alerts[escort['prison_number']]

      unless escort_alerts
        STDERR.puts "No NOMIS alerts cached for #{escort['prison_number']} so " \
        "unable to compare. Please run 'rake compare_auto_alerts:cache_alerts"
        return {}
      end

      automated_risks = Detainees::RiskMapper.new(escort_alerts,
        ensure_date(escort['date'])).call

      automated_risks.each_with_object({}) do |pair, comparison|
        attr = pair.first
        val = pair.last
        human_val = escort[attr]
        outcome = human_val == val ? 'MATCH' : 'DIFFER'
        comparison[attr] = { human: human_val, auto: val, outcome: outcome }
      end
    end

    def ensure_date(expr)
      expr.is_a?(Date) ? expr : Date.parse(expr)
    end
  end
end
