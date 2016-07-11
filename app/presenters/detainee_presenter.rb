class DetaineePresenter < SimpleDelegator
  def short_gender
    if gender == 'male'
      'M'
    elsif gender == 'female'
      'F'
    end
  end

  def age
    today = Date.today
    d = Date.new(today.year, date_of_birth.month, date_of_birth.day)
    d.year - date_of_birth.year - (d > today ? 1 : 0)
  end

  def humanized_date_of_birth
    date_of_birth.to_s(:humanized)
  end
end
