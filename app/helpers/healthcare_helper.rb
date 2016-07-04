module HealthcareHelper
  def select_values_for_carrier
    I18n.t('healthcare.show.carrier').invert
  end
end
