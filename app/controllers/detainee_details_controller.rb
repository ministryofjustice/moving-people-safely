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
    unless api_detainee_attrs.present?
      flash.now[:warning] = t('alerts.detainee.pre_filling_unavailable')
      return { prison_number: params[:prison_number] }
    end
    permitted_params(api_detainee_attrs)
  end

  def api_detainee_attrs
    @_api_detainee_attrs ||= DetaineeDetailsFetcher.new(params[:prison_number]).call
  end

  def permitted_params(params)
    params.slice(*Forms::DetaineeDetails.properties)
  end
end
