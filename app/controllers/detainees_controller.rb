class DetaineesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :redirect_if_detainee_already_exists, only: %i[new create]
  helper_method :escort

  def new
    flash.now[:warning] = t('alerts.detainee.details.unavailable')
    form = Forms::Detainee.new(escort.build_detainee)
    render locals: { form: form }
  end

  def create
    form = Forms::Detainee.new(escort.build_detainee)
    if form.validate(params[:detainee])
      form.save
      redirect_to new_escort_move_path(escort)
    else
      render :new, locals: { form: form }
    end
  end

  def edit
    form = Forms::Detainee.new(detainee)
    render locals: { form: form }
  end

  def update
    form = Forms::Detainee.new(detainee)
    if form.validate(params[:detainee])
      form.save
      redirect_to_move_or_escort
    else
      render :edit, locals: { form: form }
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def detainee
    escort.detainee || raise(ActiveRecord::RecordNotFound)
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
