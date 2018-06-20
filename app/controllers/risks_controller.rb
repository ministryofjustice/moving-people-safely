class RisksController < AssessmentsController
  steps(*Risk.sections('prison'))

  private

  def add_multiples
    return unless params.key? 'return_instructions_add_must_not_return_details'
    form.deserialize form_params
    form.add_must_not_return_detail
    view = params[:action] == 'create' ? :new : :edit
    render view
  end

  def assessment
    escort.risk || escort.build_risk
  end

  def model
    Risk
  end

  def show_page
    escort_risks_path(escort)
  end
end
