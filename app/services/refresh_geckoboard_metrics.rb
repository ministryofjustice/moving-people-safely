require 'geckoboard'

module RefreshGeckoboardMetrics
  module_function

  def call(options = {})
    logger = options.fetch(:logger, Rails.logger)
    calculator = Metrics::Calculator.new(logger: logger)
    Metrics::Exporter.new(calculator, logger: logger).call
  end
end
