class HealthcareController < ApplicationController
  include Assessable

  steps(*Healthcare.section_names)

  before_action :redirect_unless_detainee_exists
  before_action :redirect_if_healthcare_already_exists, only: %i[new create]
  before_action :redirect_unless_document_editable, except: :show
  before_action :add_multiples, only: %i[create update]

  helper_method :escort, :healthcare

  def new
    form = Forms::Assessment.for_section(escort.build_healthcare, step)
    render :new, locals: { form: form }
  end

  def create
    if form.valid?
      form.save
      update_document_workflow
      redirect_after_update
    else
      render :new, locals: { form: form }
    end
  end

  def edit
    form = Forms::Assessment.for_section(healthcare, step)
    render :edit, locals: { form: form }
  end

  def update
    if form.valid?
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

  def form
    @form ||= Forms::Assessment.for_section(healthcare, step, form_params)
  end

  def form_params
    return unless params[step]
    params[step].permit!.to_h
  end
end
