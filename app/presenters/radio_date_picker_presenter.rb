class RadioDatePickerPresenter
  DEFAULT_FORMAT = '%d/%m/%Y'.freeze
  attr_reader :attr, :value

  def initialize(attr, value)
    @attr = attr
    @normalized_attr = attr.to_s.gsub(/\[(.*)\]/, '_\1')
    @value = value
  end

  def today_label
    "#{normalized_attr}_#{today_date}"
  end

  def tomorrow_label
    "#{normalized_attr}_#{tomorrow_date}"
  end

  def today(format = DEFAULT_FORMAT)
    today_date.strftime(format)
  end

  def tomorrow(format = DEFAULT_FORMAT)
    tomorrow_date.strftime(format)
  end

  def today?
    value == today_date
  end

  def tomorrow?
    value == tomorrow_date
  end

  private

  attr_reader :normalized_attr

  def today_date
    Time.current.to_date
  end

  def tomorrow_date
    Time.current.tomorrow.to_date
  end
end
