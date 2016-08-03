class RisksController < DetaineeController
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
      redirect_to risk_path(detainee)
    end
  end

  def summary
    render 'summary/risk'
  end

  # what does error state look like?
  def confirm
    fail unless risk.all_questions_answered?
    risk_workflow.confirm_with_user!(user: current_user)
    redirect_to profile_path(active_move)
  end

  private

  def update_document_workflow
    if risk.no_questions_answered?
      risk_workflow.not_started!
    elsif risk.all_questions_answered?
      risk_workflow.unconfirmed!
    else
      risk_workflow.incomplete!
    end
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to summary_risks_path(detainee)
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
