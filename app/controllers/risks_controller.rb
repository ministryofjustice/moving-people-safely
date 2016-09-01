class RisksController < DetaineeController
  include Wicked::Wizard
  include Wizardable

  steps *%i[
      risk_to_self
      risk_from_others
      violence
      harassments
      sex_offences
      non_association_markers
      security
      substance_misuse
      concealed_weapons
      arson
      communication
    ]

  def show
    if flash[:form_data]
      form.assign_attributes flash[:form_data]
      form.validate
    end
    render :show, locals: { form: form, template_name: step.to_s }
  end

  def update
    form.assign_attributes permitted_params
    if form.save
      update_document_workflow
      redirect_after_update
    else
      flash[:form_data] = permitted_params
      redirect_to risk_path(detainee)
    end
  end

  def summary
    sections = wizard_steps.map { |section| Considerations::FormFactory.new(detainee).(section) }
    render 'summary/risk', locals: { sections: sections }
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

  def permitted_params
    form.models.map(&:name).inject({}) do |acc, name|
      acc[name] = params.require(name).permit!.to_h
      acc
    end
  end

  def form
    @_form ||= Considerations::FormFactory.new(detainee).(step)
  end
end
