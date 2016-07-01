module HealthcareHelper
  def select_values_for_carrier
    I18n.t('healthcare.carrier').invert
  end

  def title(template_name)
    t(".#{template_name}")
  end
end
