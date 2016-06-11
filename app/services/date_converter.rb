module DateConverter
  module_function

  def convert(date)
    if date.is_a? String
      Date.strptime(date, "%d/%m/%Y")
    else
      date
    end
  rescue ArgumentError
    date
  end
end
