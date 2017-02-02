class DetaineesController < ApplicationController
  attr_reader :detainee, :move
  alias active_move move
  before_action :redirect_if_detainee_exists, only: %i[new create]
  before_action :find_detainee_data, only: %i[edit update]

  def new
    form = Forms::Detainee.new(Detainee.new(detainee_default_attrs))
    render locals: { form: form }
  end

  def create
    form = Forms::Detainee.new(Detainee.new)
    if form.validate(params[:detainee])
      form.save
      redirect_to new_detainee_move_path(form.model)
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
      redirect_to_move_or_profile
    else
      render :edit, locals: { form: form }
    end
  end

  def show
    @detainee = Detainee.find(params[:id])
    @move = detainee.active_move
  end

  private

  def find_detainee_data
    @detainee = Detainee.find(params[:id])
    @move = detainee.active_move
  end

  def detainee_default_attrs
    return {} unless params[:prison_number].present?
    if detainee_api_error.present?
      flash.now[:warning] = pre_filling_error_message
      return { prison_number: params[:prison_number] }
    end
    permitted_params(detainee_api_attrs)
  end

  def pre_filling_error_message
    case detainee_api_error
    when 'api_error', 'internal_error'
      t('alerts.detainee.pre_filling_unavailable')
    when 'details_not_found'
      t('alerts.detainee.details_not_found')
    when 'invalid_input'
      t('alerts.detainee.invalid_input')
    end
  end

  def detainee_api_response
    @_api_detainee_response ||= DetaineeDetailsFetcher.new(params[:prison_number]).call
  end

  def detainee_api_attrs
    detainee_api_response && detainee_api_response.details
  end

  def detainee_api_error
    detainee_api_response && detainee_api_response.error
  end

  def permitted_params(params)
    params.slice(*Forms::Detainee.properties)
  end

  def redirect_to_move_or_profile(options = {})
    if active_move.present?
      redirect_to detainee_path(detainee), options
    elsif detainee.moves.any?
      redirect_to copy_move_path(detainee), options
    else
      redirect_to new_detainee_move_path(detainee), options
    end
  end

  def redirect_if_detainee_exists
    return unless params[:prison_number].present?
    @detainee = Detainee.find_by_prison_number(params[:prison_number])
    return unless @detainee
    redirect_to_move_or_profile(flash: { warning: t('alerts.detainee_already_exists') })
  end
end
