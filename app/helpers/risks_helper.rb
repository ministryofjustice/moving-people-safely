module RisksHelper
  def heightened_observation_yes_no(level)
    if Forms::Risk::RiskToSelf::OBSERVATION_LEVELS_REQUIRING_DETAILS.include?(level)
      'yes'
    else
      'no'
    end
  end

  def full_observation_level_details(level, details)
    return '' if level == Forms::Risk::RiskToSelf::OBSERVATION_LEVELS.first

    "#{I18n.t(level, scope: %i[helpers label risk_to_self observation_level_choices])}. #{details}"
  end
end
