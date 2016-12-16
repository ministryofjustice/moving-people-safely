module HealthcareHelper
  def select_values_for_carrier
    I18n.t('healthcare.form.title.carrier').invert
  end
end
