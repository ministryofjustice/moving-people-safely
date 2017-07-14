namespace :geckoboard do
  namespace :metrics do
    desc 'Refreshes Geckoboard metrics'
    task refresh: :environment do
      RefreshGeckoboardMetrics.call(logger: Logger.new(STDOUT))
    end
  end
end
