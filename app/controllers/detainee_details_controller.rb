class DetaineeDetailsController < DocumentController
  def show
    form.validate(flash[:form_data]) if flash[:form_data]
    render :show, locals: { form: form }
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

  def redirect_to_move_or_profile
    if escort.with_future_move?
      redirect_to profile_path(escort)
    else
      redirect_to move_information_path(escort)
    end
  end

  def form
    @_form ||= Forms::DetaineeDetails.new(detainee)
  end
end
