require 'geckoboard'

module RefreshGeckoboardMetrics
  def call(options = {})
    logger = options.fetch(:logger, Rails.logger)
    metrics = Metrics::Calculator.new(logger: logger).call
    Metrics::Exporter.new(metrics, logger: logger).call
  end
  module_function :call
end
