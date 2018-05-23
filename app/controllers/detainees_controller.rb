class DetaineesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :redirect_if_detainee_already_exists, only: %i[new create]
  helper_method :escort, :form

  def new
    flash.now[:warning] = t('alerts.detainee.details.unavailable')
  end

  def create
    if form.validate(params[:detainee])
      form.save
      redirect_to new_escort_move_path(escort)
    else
      render :new
    end
  end

  def update
    if form.validate(params[:detainee])
      form.save
      redirect_to_move_or_escort
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

  def redirect_to_move_or_escort(options = {})
    if escort.move
      redirect_to escort_path(escort), options
    else
      redirect_to new_escort_move_path(escort), options
    end
  end
end
