class AnalyticsEvent
  def self.publish(event, **params)
    instrumentation_class = instrumentation_class_from_params(params)
    instrumentation_class.instrument(event, **params) do
      yield if block_given?
    end
  end

  def self.instrumentation_class_from_params(params)
    params.delete(:instrumentation_class) { |_| ActiveSupport::Notifications }
  end
end
