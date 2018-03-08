require 'csv'

# In Google sheets use this formula:
#   =query(A1:G53,"select D, count(D) group by D pivot G")

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
        fetch(prison_number, api_client)
      end

      STDOUT.flush
      STDERR.flush
    end

    STDOUT.puts 'Updating cache'
    File.open(FILE, 'w') { |f| f.write(alerts.to_json) }
  end

  private

  attr_reader :limit

  def fetch(prison_number, api_client)
    alerts[prison_number] = api_client.get(
      "/offenders/#{prison_number}/alerts"
    )
    STDOUT.puts 'done'
    sleep SLEEP unless (i + 1) == limit
  rescue => e
    STDERR.puts "error fetching from NOMIS: #{e.message}"
  end
end

class EscortFetcher
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
    alerts = alerts[escort['prison_number']]

    unless alerts
      STDERR.puts "No NOMIS alerts cached for #{escort['prison_number']} so " \
        "unable to compare. Please run 'rake compare_auto_alerts:cache_alerts"
      return {}
    end

    automated_risks = Detainees::RiskMapper.new(alerts,
      Date.parse(escort['date'])).call

    automated_risks.each_with_object({}) do |pair, comparison|
      attr = pair.first
      val = pair.last
      human_val = escort[attr]
      outcome = human_val == val ? 'MATCH' : 'DIFFER'
      comparison[attr] = { human: human_val, auto: val, outcome: outcome }
    end
  end
end

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

def limit
  ENV.fetch('LIMIT', 200).to_i
end

namespace :compare_auto_alerts do
  desc 'Fetch and cache alerts from NOMIS API for the last LIMIT of issued PERs'
  task cache_alerts: :environment do
    prison_numbers = EscortFetcher.new(limit).escorts.map { |e| e['prison_number'] }
    NomisCache.new(limit).refresh(prison_numbers)
  end

  desc 'Compare the last LIMIT of issued PER alerts with what would have ' \
       'been generated automatically. Output as CSV.'
  task csv: %i[environment cache_alerts] do
    cached_alerts = NomisCache.new(limit).alerts
    raise "No cached NOMIS alerts. Please run 'rake compare:nomis_cache" unless cached_alerts.any?

    comparisons = EscortFetcher.new(limit).compare(cached_alerts)
    STDOUT.puts CsvWriter.write(comparisons)
  end
end
