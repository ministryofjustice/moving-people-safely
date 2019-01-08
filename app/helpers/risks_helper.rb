# frozen_string_literal: true

module RisksHelper
  def full_observation_level_details(level, details)
    "#{I18n.t(level, scope: %i[helpers label risk_to_self observation_level_choices])}. #{details}"
  end
end
