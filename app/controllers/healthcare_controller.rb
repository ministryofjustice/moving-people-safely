class HealthcareController < AssessmentsController
  steps(*Healthcare.sections('prison'))

  private

  def add_multiples
    return unless params.key? 'needs_add_medication'
    form.deserialize form_params
    form.add_medication
    view = params[:action] == 'create' ? :new : :edit
    render view
  end

  def assessment
    escort.healthcare || escort.build_healthcare
  end

  def model
    Healthcare
  end

  def show_page
    escort_healthcare_path(escort)
  end
end
