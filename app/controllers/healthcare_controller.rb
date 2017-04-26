class HealthcareController < ApplicationController
  include Wicked::Wizard
  include Wizardable

  steps(*HealthcareWorkflow.sections)

  before_action :redirect_unless_document_editable, except: :summary
  before_action :add_medication, only: [:update]

  helper_method :escort, :healthcare

  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    form.prepopulate!
    render :show, locals: { form: form }
  end

  def update
    if form.validate form_params
      form.save
      update_document_workflow
      redirect_after_update
    else
      flash[:form_data] = form_params
      redirect_to escort_healthcare_path(escort, step: step)
    end
  end

  def summary
    render 'summary/healthcare'
  end

  def confirm
    raise unless healthcare.all_questions_answered?
    healthcare.confirm!(user: current_user)
    redirect_to escort_path(escort)
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def healthcare
    escort.healthcare || raise(ActiveRecord::RecordNotFound)
  end

  def update_document_workflow
    if healthcare.no_questions_answered?
      healthcare.not_started!
    elsif healthcare.all_questions_answered?
      healthcare.unconfirmed!
    else
      healthcare.incomplete!
    end
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to summary_escort_healthcare_path(escort)
    else
      redirect_to next_wizard_path
    end
  end

  def add_medication
    if params.key? 'needs_add_medications'
      form.deserialize form_params
      form.add_medication
      render :show, locals: { form: form }
    end
  end

  def form_params
    params[step]
  end

  def form
    @_form ||= form_for_section(step).new(healthcare)
  end

  def form_for_section(section)
    "Forms::Healthcare::#{section.to_s.camelcase}".constantize
  end
end
