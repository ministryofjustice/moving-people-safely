# frozen_string_literal: true

class OffencesController < ApplicationController
  before_action :redirect_unless_document_editable, except: :show
  before_action :add_offence, only: [:update]

  helper_method :escort, :form, :offences, :offences_workflow

  def show
    flash.now[:warning] = t('alerts.offences.not_found') if escort.from_prison? && escort.offences.none?
    form.prepopulate!
  end

  def update
    if form.validate form_data
      form.save
      offences_workflow.confirm!(user: current_user)
      redirect_to escort_path(escort)
    else
      form.prepopulate!
      render :show
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def offences
    escort.offences
  end

  def offences_workflow
    escort.offences_workflow || escort.build_offences_workflow
  end

  def add_offence
    return unless params.key? 'offences_add_offence'

    form.deserialize form_data
    form.add_offence
    render :show
  end

  def form_data
    params.require(:offences)
  end

  def form
    @form ||= Forms::Offences.new(escort)
  end
end
