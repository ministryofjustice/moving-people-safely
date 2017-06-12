class TimeDiff
  include ActionView::Helpers::TextHelper

  attr_reader :start_time, :end_time, :components

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
    @components = calculate_components
  end

  def to_s
    non_zero_components = components.reject { |_key, value| value.zero? }
    non_zero_components.each_with_object([]) do |(key, value), array|
      array << pluralize(value, key.to_s)
    end.join(', ')
  end

  private

  def calculate_components
    diff = (start_time - end_time).to_i.abs
    mm, ss = diff.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    { day: dd, hour: hh, minute: mm, second: ss }
  end
end
