class HealthcareController < AssessmentsController
  steps(*Healthcare::SECTIONS)

  private

  def add_multiples
    return unless params.key? 'needs_add_medication'
    form.deserialize form_params
    form.add_medication
    view = params[:action] == 'create' ? :new : :edit
    render view, locals: { form: form }
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
