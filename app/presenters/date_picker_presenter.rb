class DatePickerPresenter
  FORMAT = '%d/%m/%Y'.freeze

  attr_reader :date

  def initialize(date_str)
    @date = cast_or_default(date_str)
  end

  def configure(args)
    case args[:date_shift]
    when 'today'
      AnalyticsEvent.publish('date_change', new_date: :today)
      today
    when '<'
      AnalyticsEvent.publish('date_change', new_date: :back)
      back
    when '>'
      AnalyticsEvent.publish('date_change', new_date: :forward)
      forward
    when 'Go'
      AnalyticsEvent.publish('date_change', new_date: args[:date])
      @date = cast(args[:date]) if valid?(args[:date])
    end
  end

  def to_s
    @date.strftime(FORMAT)
  end

  def forward
    @date += 1.day
  end

  def back
    @date -= 1.day
  end

  def today
    @date = Date.today
  end

  private

  def cast_or_default(date_str, default = Date.today)
    cast(date_str)
  rescue
    default
  end

  def valid?(string_date)
    cast(string_date)
    true
  rescue
    false
  end

  # this will explode if the string doesn't match
  def cast(string_date)
    Date.strptime(string_date, FORMAT)
  end
end
