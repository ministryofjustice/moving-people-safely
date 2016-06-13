class HealthcareCell < Cell::ViewModel
  alias_method :form, :model

  def form_path
    physical_path(form.model.escort)
  end
end
