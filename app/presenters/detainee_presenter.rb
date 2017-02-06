class DetaineePresenter < SimpleDelegator
  def short_gender
    if gender == 'male'
      'M'
    elsif gender == 'female'
      'F'
    end
  end

  def humanized_date_of_birth
    date_of_birth.to_s(:humanized)
  end
end
