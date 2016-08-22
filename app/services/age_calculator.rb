module AgeCalculator
module_function

  def age(date_of_birth, today = Time.zone.today)
    adjustment = had_birthday_this_year?(date_of_birth, today) ? 0 : 1
    today.year - date_of_birth.year - adjustment
  end

  def had_birthday_this_year?(date_of_birth, today)
    today.month > date_of_birth.month ||
      (today.month == date_of_birth.month && today.day >= date_of_birth.day)
  end

  private_class_method :had_birthday_this_year?
end
