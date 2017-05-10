class RisksController < ApplicationController
  include Wicked::Wizard
  include Wizardable

  steps(*Risk.section_names)

  before_action :redirect_unless_document_editable, except: :summary

  helper_method :escort, :risk

  def show
    form = Forms::Assessment.for_section(risk, step)
    render :show, locals: { form: form }
  end

  def update
    form = Forms::Assessment.for_section(risk, step, form_params)
    if form.valid?
      form.save
      update_document_workflow
      redirect_after_update
    else
      render :show, locals: { form: form }
    end
  end

  def summary
    render 'summary/risk'
  end

  def confirm
    if risk.all_questions_answered?
      risk.confirm!(user: current_user)
      redirect_to escort_path(escort)
    else
      flash.now[:error] = t('alerts.unable_to_confirm_incomplete_risk_assessment')
      render 'summary/risk'
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def risk
    escort.risk || raise(ActiveRecord::RecordNotFound)
  end

  def update_document_workflow
    if risk.no_questions_answered?
      risk.not_started!
    elsif risk.all_questions_answered?
      risk.unconfirmed!
    else
      risk.incomplete!
    end
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to summary_escort_risks_path(escort)
    else
      redirect_to next_wizard_path
    end
  end

  def form_params
    return unless params[step]
    params[step].permit!.to_h
  end
end
