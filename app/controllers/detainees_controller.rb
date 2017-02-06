class DetaineesController < ApplicationController
  attr_reader :detainee, :move
  alias active_move move
  before_action :redirect_if_detainee_exists, only: %i[new create]
  before_action :find_detainee_data, only: %i[edit update]

  def new
    form = Forms::Detainee.new(Detainee.new(default_attrs))
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
    detainee.assign_attributes(extra_attrs)
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

  def set_default_attrs
    return {} unless params[:prison_number].present?
    status, remote_attrs = fetch_response_for(params[:prison_number])
    flash_fetcher_errors(status.errors) if status.error?
    permitted_params(remote_attrs)
  end

  def default_attrs
    @default_attrs ||= set_default_attrs
  end

  def set_extra_attrs
    options = { pull: :none }
    options = params.slice(:pull) if params[:pull]
    status, remote_attrs = fetch_response_for(detainee.prison_number, options)
    flash_fetcher_errors(status.errors) if status.error?
    permitted_params(remote_attrs)
  end

  def extra_attrs
    @extra_attrs ||= set_extra_attrs
  end

  def flash_fetcher_errors(errors)
    errors.each do |error|
      message = t("alerts.detainee.#{error}")
      flash.now[:warning] ||= []
      flash.now[:warning] << message
    end
  end

  def fetch_response_for(prison_number, options = {})
    fetcher_response = Detainees::Fetcher.new(prison_number, options).call
    remote_attrs = fetcher_response.to_h.merge(prison_number: prison_number).with_indifferent_access
    [fetcher_response, remote_attrs]
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
