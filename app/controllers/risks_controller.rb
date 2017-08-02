class RisksController < ApplicationController
  include Assessable

  steps(*Risk.section_names)

  before_action :redirect_unless_detainee_exists
  before_action :redirect_if_risk_already_exists, only: %i[new create]
  before_action :redirect_unless_document_editable, except: :show
  before_action :add_multiples, only: %i[create update]

  helper_method :escort, :risk

  def new
    form = Forms::Assessment.for_section(escort.build_risk, step)
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
    form = Forms::Assessment.for_section(risk, step)
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

  def confirm
    if risk.all_questions_answered?
      risk.confirm!(user: current_user)
      track_events.call
      redirect_to escort_path(escort)
    else
      flash.now[:error] = t('alerts.unable_to_confirm_assessment', assessment: 'Risk')
      render :show
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def risk
    @risk ||= if %w[new create].include?(params[:action])
                escort.build_risk
              else
                escort.risk || raise(ActiveRecord::RecordNotFound)
              end
  end

  def update_document_workflow
    if risk.all_questions_answered?
      risk.unconfirmed!
    else
      risk.incomplete!
    end
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to escort_risks_path(escort)
    else
      redirect_to next_wizard_path(action: :edit)
    end
  end

  def redirect_if_risk_already_exists
    redirect_to escort_risks_path(escort) if escort.risk
  end

  def form
    @form ||= Forms::Assessment.for_section(risk, step, form_params)
  end

  def form_params
    return unless params[step]
    params[step].permit!.to_h
  end

  def track_events
    TrackEvents.new(current_user, escort, :risks_complete, request)
  end
end
