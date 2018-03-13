module CompareAutoAlerts
  class NomisCache
    FILE = 'compare_nomis_cache.json'.freeze
    SLEEP = 5

    attr_reader :alerts

    def initialize(limit)
      @alerts = File.exist?(FILE) ? JSON.parse(File.read(FILE)) : {}
      @limit = limit
    end

    def refresh(prison_numbers)
      api_client = Nomis::Api.instance

      prison_numbers.each_with_index do |prison_number, i|
        counter = "#{i + 1}/#{limit}"

        if alerts[prison_number]
          STDOUT.puts "#{counter}: #{prison_number}: Cached"
        else
          STDOUT.print "#{counter}: #{prison_number}: Fetching... "
          fetch(prison_number, api_client, (i + 1) == limit)
        end

        STDOUT.flush
        STDERR.flush
      end

      STDOUT.puts 'Updating cache'
      File.open(FILE, 'w') { |f| f.write(alerts.to_json) }
    end

    private

    attr_reader :limit

    def fetch(prison_number, api_client, last = false)
      alerts[prison_number] = api_client.get(
        "/offenders/#{prison_number}/alerts"
      )
      STDOUT.puts 'done'
      sleep SLEEP unless last
    rescue => e
      STDERR.puts "error fetching from NOMIS: #{e.message}"
    end
  end
end
