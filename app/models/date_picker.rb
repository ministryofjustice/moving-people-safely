class DatePicker
  FORMAT = '%d/%m/%Y'

  def initialize(date_from_session)
    if date_from_session.present?
      send(:date=, date_from_session)
    else
      today
    end
  end

  def date
    @date || today
  end

  def to_s
    if @date.present?
      @date.strftime(FORMAT)
    else
      @string_date.to_s
    end
  end

  def date=(string_date)
    @string_date = string_date
    set_date_if_valid
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
    @date = Date.today
  end

  private

  def set_date_if_valid
    @date = cast(@string_date) if valid?(@string_date)
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
