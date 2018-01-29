class DetaineesController < ApplicationController
  before_action :redirect_unless_document_editable
  helper_method :escort

  def edit
    detainee.assign_attributes(extra_attrs) if params[:pull]
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

  def default_prison_number
    escort.prison_number
  end

  def set_extra_attrs
    options = params.slice(:pull)
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

  def redirect_to_move_or_escort(options = {})
    if escort.move
      redirect_to escort_path(escort), options
    else
      redirect_to new_escort_move_path(escort), options
    end
  end
end
