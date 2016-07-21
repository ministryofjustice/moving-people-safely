class RisksController < DocumentController
  include Wicked::Wizard
  include Wizardable

  steps :risk_to_self, :risk_from_others, :violence, :harassments,
    :sex_offences, :non_association_markers, :security, :substance_misuse,
    :concealed_weapons, :arson, :communication

  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    form.prepopulate!
    render :show, locals: { form: form, template_name: form.class.name }
  end

  def update
    if form.validate form_params
      form.save
      update_document_workflow
      redirect_after_update
    else
      flash[:form_data] = form_params
      redirect_to risk_path(escort)
    end
  end

  def summary
    render 'summary/risk'
  end

  private

  def update_document_workflow
    workflow = DocumentWorkflow.new(risk)
    workflow.update_status(:complete) ||
      workflow.update_status(:incomplete)
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to summary_risks_path(escort)
    else
      redirect_to next_wizard_path
    end
  end

  def form_params
    params[step]
  end

  def form
    @_form ||= {
      risk_to_self: Forms::Risk::RiskToSelf,
      risk_from_others: Forms::Risk::RiskFromOthers,
      violence: Forms::Risk::Violence,
      harassments: Forms::Risk::Harassments,
      sex_offences: Forms::Risk::SexOffences,
      non_association_markers: Forms::Risk::NonAssociationMarkers,
      security: Forms::Risk::Security,
      substance_misuse: Forms::Risk::SubstanceMisuse,
      concealed_weapons: Forms::Risk::ConcealedWeapons,
      arson: Forms::Risk::Arson,
      communication: Forms::Risk::Communication
    }[step].new(risk)
  end
end
