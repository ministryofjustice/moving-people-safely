# In Google sheets use this formula:
#   =query(A1:G53,"select D, count(D) group by D pivot G")

def limit
  ENV.fetch('LIMIT', 200).to_i
end

namespace :compare_auto_alerts do
  desc 'Fetch and cache alerts from NOMIS API for the last LIMIT of issued PERs'
  task cache_alerts: :environment do
    prison_numbers = CompareAutoAlerts::EscortsFetcher.new(limit).escorts.map { |e| e['prison_number'] }
    CompareAutoAlerts::NomisCache.new(limit).refresh(prison_numbers)
  end

  desc 'Compare the last LIMIT of issued PER alerts with what would have ' \
       'been generated automatically. Output as CSV.'
  task csv: %i[environment cache_alerts] do
    cached_alerts = CompareAutoAlerts::NomisCache.new(limit).alerts
    raise "No cached NOMIS alerts. Please run 'rake compare:nomis_cache" unless cached_alerts.any?

    comparisons = CompareAutoAlerts::EscortsFetcher.new(limit).compare(cached_alerts)
    STDOUT.puts CompareAutoAlerts::CsvWriter.write(comparisons)
  end
end
