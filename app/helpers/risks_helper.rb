module RisksHelper
  def heightened_observation_yes_no(level)
    if Forms::Risk::RiskToSelf::OBSERVATION_LEVELS_REQUIRING_DETAILS.include?(level)
      'yes'
    else
      'no'
    end
  end

  def full_observation_level_details(risk)
    return '' if risk.observation_level == Forms::Risk::RiskToSelf::OBSERVATION_LEVELS.first

    details = risk.public_send("observation_#{risk.observation_level}_details")
    "#{I18n.t(risk.observation_level, scope: %i[helpers label risk_to_self observation_level_choices])}. #{details}"
  end
end
