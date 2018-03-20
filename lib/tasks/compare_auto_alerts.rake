# In Google sheets use this formula:
#   =query(A1:G53,"select D, count(D) group by D pivot G")

namespace :analysis do
  desc 'Compare the last LIMIT of issued PER alerts with what would have ' \
       'been generated automatically. Output as CSV.'
  task compare_auto_alerts: :environment do
    comparisons = CompareAutoAlerts::Compare.new.call
    STDOUT.puts CompareAutoAlerts::CsvWriter.write(comparisons)
  end
end
