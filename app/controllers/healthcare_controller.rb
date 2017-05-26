class HealthcareController < ApplicationController
  include Wicked::Wizard
  include Wizardable

  steps(*Healthcare.section_names)

  before_action :redirect_unless_detainee_exists
  before_action :redirect_if_healthcare_already_exists, only: %i[new create]
  before_action :redirect_unless_document_editable, except: :show
  before_action :add_medication, only: %i[create update]

  helper_method :escort, :healthcare

  def new
    form.prepopulate!
    render :new, locals: { form: form }
  end

  def create
    if form.validate form_params
      form.save
      update_document_workflow
      redirect_after_update
    else
      render :new, locals: { form: form }
    end
  end

  def edit
    form.prepopulate!
    render :edit, locals: { form: form }
  end

  def update
    if form.validate form_params
      form.save
      update_document_workflow
      redirect_after_update
    else
      render :edit, locals: { form: form }
    end
  end

  def intro
    if Healthcare.has_intro?
      render 'shared/wizard_intro',
        locals: { intro: AssessmentIntroPresenter.new(:healthcare),
                  assessment: escort.healthcare }
    else
      redirect_to assessment_wizard_path(escort.healthcare)
    end
  end

  def confirm
    if healthcare.all_questions_answered?
      healthcare.confirm!(user: current_user)
      redirect_to escort_path(escort)
    else
      flash.now[:error] = t('alerts.unable_to_confirm_assessment', assessment: 'Healthcare')
      render :show
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def healthcare
    @healthcare ||= if %w[new create].include?(params[:action])
                      escort.build_healthcare
                    else
                      escort.healthcare || raise(ActiveRecord::RecordNotFound)
                    end
  end

  def update_document_workflow
    if healthcare.all_questions_answered?
      healthcare.unconfirmed!
    else
      healthcare.incomplete!
    end
  end

  def redirect_if_healthcare_already_exists
    redirect_to escort_healthcare_path(escort) if escort.healthcare
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to escort_healthcare_path(escort)
    else
      redirect_to next_wizard_path(action: :edit)
    end
  end

  def add_medication
    if params.key? 'needs_add_medications'
      form.deserialize form_params
      form.add_medication
      view = params[:action] == 'create' ? :new : :edit
      render view, locals: { form: form }
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
