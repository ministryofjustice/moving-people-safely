# frozen_string_literal: true

class AssessmentsController < ApplicationController
  before_action :set_steps

  include Wicked::Wizard
  include Wizardable

  before_action :redirect_unless_detainee_exists
  before_action :redirect_if_assessment_already_exists, only: %i[new create]
  before_action :redirect_unless_document_editable, except: %i[show automation]
  before_action :add_multiples, only: %i[create update]

  helper_method :escort, :assessment, :form

  def new
    form.prepopulate!
  end

  def create
    if form.validate form_params
      form.save
      update_document_workflow
      redirect_after_update
    else
      form.prepopulate!
      render :new
    end
  end

  def edit
    form.prepopulate!
  end

  def update
    if form.validate form_params
      form.save
      update_document_workflow
      redirect_after_update
    else
      form.prepopulate!
      render :edit
    end
  end

  def confirm
    if assessment.all_questions_answered?
      assessment.confirm!(user: current_user)
      redirect_to escort_path(escort)
    else
      flash.now[:error] = t('alerts.unable_to_confirm_assessment', assessment: model.to_s)
      render :show
    end
  end

  private

  def set_steps
    self.steps = model.sections(escort.location)
  end

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def form
    @form ||= form_for_step.new(assessment)
  end

  def form_for_step
    "Forms::#{model}::#{step.camelcase}".constantize
  end

  def form_params
    return {} unless params[step]

    params[step].permit!
  end

  def update_document_workflow
    if assessment.all_questions_answered?
      assessment.unconfirmed!
    else
      assessment.incomplete!
    end
  end

  def redirect_if_assessment_already_exists
    redirect_to show_page if assessment.persisted?
  end

  def redirect_after_update
    if params.key?('save_and_view_summary') || !can_skip?
      redirect_to show_page
    else
      redirect_to next_wizard_path(action: :edit)
    end
  end

  def add_multiples
    return unless params.key? "#{multiples[:section]}_add_#{multiples[:field]}"

    form.deserialize form_params
    form.public_send("add_#{multiples[:field]}")
    view = params[:action] == 'create' ? :new : :edit
    render view
  end
end
