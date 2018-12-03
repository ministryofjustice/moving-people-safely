# frozen_string_literal: true

class DetaineesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :redirect_if_detainee_already_exists, only: %i[new create]
  helper_method :escort, :form

  def new
    flash.now[:warning] = t('alerts.detainee.details.unavailable') if escort.from_prison?
  end

  def create
    if form.validate(params[:detainee])
      form.save
      redirect_to escort_path(escort)
    else
      render :new
    end
  end

  def update
    if form.validate(params[:detainee])
      form.save
      redirect_to escort_path(escort)
    else
      render :edit
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def form
    @form ||= Forms::Detainee.new(escort.detainee || escort.build_detainee)
  end

  def permitted_params(params)
    params.slice(*Forms::Detainee.properties)
  end

  def redirect_if_detainee_already_exists
    redirect_to new_escort_move_path(escort), alert: t('alerts.escort.detainee.exists') if escort.detainee
  end
end
