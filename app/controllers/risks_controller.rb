class RisksController < DetaineeController
  include Wicked::Wizard
  include Wizardable

  steps(*RiskWorkflow.sections)

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

  def confirm
    if risk.all_questions_answered?
      risk_workflow.confirm_with_user!(user: current_user)
      redirect_to detainee_path(detainee)
    else
      flash.now[:error] = t('alerts.unable_to_confirm_incomplete_risk_assessment')
      render 'summary/risk'
    end
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
    @_form ||= form_for_risk_section(step).new(risk)
  end

  def form_for_risk_section(section)
    "Forms::Risk::#{section.to_s.camelcase}".constantize
  end
end
