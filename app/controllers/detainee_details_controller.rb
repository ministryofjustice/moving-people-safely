class DetaineeDetailsController < DetaineeController
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
    if active_move.present?
      redirect_to profile_path(active_move)
    if detainee.moves.any?
      redirect_to copy_move_path(detainee)
    else
      redirect_to new_move_path(detainee)
    end
  end

  def form
    @_form ||= Forms::DetaineeDetails.new(detainee)
  end
end
