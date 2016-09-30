class HealthcareController < DetaineeController
  include Wicked::Wizard
  include Wizardable

  steps *%i[
      physical_issues
      mental_healthcare
      social_healthcare
      allergies
      healthcare_needs
      transport
      medical_contact
    ]

  before_action :add_medication, only: [:update]

  def show
    if flash[:form_data]
      form.assign_attributes(flash[:form_data])
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
      redirect_to healthcare_path(detainee)
    end
  end

  def summary
    sections = wizard_steps.map { |section| Considerations::FormFactory.new(detainee).(section) }
    render 'summary/healthcare', locals: { sections: sections }
  end

  def confirm
    fail unless healthcare.all_questions_answered?
    healthcare_workflow.confirm_with_user!(user: current_user)
    redirect_to profile_path(active_move)
  end

  private

  def update_document_workflow
    if healthcare.no_questions_answered?
      healthcare_workflow.not_started!
    elsif healthcare.all_questions_answered?
      healthcare_workflow.unconfirmed!
    else
      healthcare_workflow.incomplete!
    end
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to summary_healthcare_index_path(detainee)
    else
      redirect_to next_wizard_path
    end
  end

  def add_medication
    if params.key? 'needs_add_medication'
      form.assign_attributes permitted_params
      form.medications.add
      flash[:form_data] = form.to_params
      redirect_to healthcare_path(detainee)
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
