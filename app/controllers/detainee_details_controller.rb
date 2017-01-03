class DetaineeDetailsController < DetaineeController
  skip_before_action :redirect_unless_document_editable, only: %i[new create]
  before_action :redirect_if_detainee_exists, only: %i[new create]

  def new
    form = Forms::DetaineeDetails.new(Detainee.new(detainee_default_attrs))
    render :show, locals: { form: form, submit_path: detainee_path }
  end

  def create
    form = Forms::DetaineeDetails.new(Detainee.new)
    if form.validate(params[:detainee_details])
      form.save
      redirect_to new_move_path(form.model.id)
    else
      render :show, locals: { form: form, submit_path: detainee_path }
    end
  end

  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    render :show, locals: { form: form, submit_path: detainee_details_path(detainee) }
  end

  def update
    if form.validate(params[:detainee_details])
      form.save
      redirect_to_move_or_profile
    else
      flash[:form_data] = params[:detainee_details]
      redirect_to detainee_details_path(detainee)
    end
  end

  private

  def redirect_if_detainee_exists
    return unless params[:prison_number].present?
    @_detainee = Detainee.find_by_prison_number(params[:prison_number])
    return unless @_detainee
    redirect_to_move_or_profile(flash: { warning: t('alerts.detainee_already_exists') })
  end

  def redirect_to_move_or_profile(options = {})
    if active_move.present?
      redirect_to profile_path(active_move), options
    elsif detainee.moves.any?
      redirect_to copy_move_path(detainee), options
    else
      redirect_to new_move_path(detainee), options
    end
  end

  def form
    @_form ||= Forms::DetaineeDetails.new(detainee)
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
    params.slice(*Forms::DetaineeDetails.properties)
  end
end
