class OffencesController < DocumentController
  before_action :add_offence, only: [:update]

  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    form.prepopulate!
    render locals: { form: form }
  end

  def update
    if form.validate form_data
      form.save
      update_document_workflow
      redirect_to profile_path(escort)
    else
      flash[:form_data] = form_data
      redirect_to offences_path(escort)
    end
  end

  private

  def update_document_workflow
    workflow = DocumentWorkflow.new(offences)
    workflow.update_status(:complete) ||
      workflow.update_status(:incomplete)
  end

  def add_offence
    if params.key? 'offences_add_offence'
      form.deserialize form_data
      form.add_current_offence
      render :show, locals: { form: form }
    elsif params.key? 'offences_add_past_offence'
      form.deserialize form_data
      form.add_past_offence
      render :show, locals: { form: form }
    end
  end

  def form_data
    params.require(:offences)
  end

  def form
    @_form ||= Forms::Offences.new(offences)
  end
end
