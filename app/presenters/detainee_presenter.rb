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

  def short_ethnicity
    return 'White: British' if ethnicity == 'White: Eng./Welsh/Scot./N.Irish/British'
    ethnicity
  end

  def expanded_interpreter_required
    return 'Not required' if interpreter_required == 'no'
    interpreter_required&.capitalize
  end
end
