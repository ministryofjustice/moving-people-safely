class HealthcareController < DetaineeController
  include Wicked::Wizard
  include Wizardable

  steps :physical, :mental, :social, :allergies, :needs, :transport, :contact

  before_action :add_medication, only: [:update]

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
      redirect_to healthcare_path(detainee)
    end
  end

  def summary
    render 'summary/healthcare'
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
      form.deserialize form_params
      form.add_medication
      render :show, locals: { form: form, template_name: form.class.name }
    end
  end

  def form_params
    params[step]
  end

  def form
    @_form ||= {
      physical: Forms::Healthcare::Physical,
      mental: Forms::Healthcare::Mental,
      social: Forms::Healthcare::Social,
      allergies: Forms::Healthcare::Allergies,
      needs: Forms::Healthcare::Needs,
      transport: Forms::Healthcare::Transport,
      contact: Forms::Healthcare::Contact
    }[step].new(healthcare)
  end
end
