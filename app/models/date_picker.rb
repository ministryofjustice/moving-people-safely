class DatePicker
  DEFAULT_FORMAT = '%d/%m/%Y'.freeze
  SUPPORTED_FORMATS = ['%d/%m/%Y', '%d-%m-%Y', '%d %m %Y'].freeze

  include Comparable

  def initialize(new_date)
    new_date.present? ? send(:date=, new_date) : today
  end

  def date
    @date || today
  end

  def date=(string_date)
    @string_date = string_date
    set_date_if_valid
  end

  def to_s
    if @date.present?
      @date.strftime(DEFAULT_FORMAT)
    else
      @string_date.to_s
    end
  end

  def ==(other)
    Date.parse(to_s) == Date.parse(other.to_s)
  rescue
    false
  end

  def forward
    @date || today
    @date += 1.day
  end

  def back
    @date || today
    @date -= 1.day
  end

  def today
    @date = Date.current
  end

  private

  def set_date_if_valid
    @date = cast(@string_date) if valid?(@string_date)
  end

  def valid?(string_date)
    cast(string_date)
  end

  def cast(date_str)
    SUPPORTED_FORMATS.each do |format|
      cast_value = cast_with_format(date_str, format)
      return cast_value if cast_value
    end
    nil
  end

  def cast_with_format(date_str, format)
    Date.strptime(date_str, format)
  rescue
    nil
  end
end
