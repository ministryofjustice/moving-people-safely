class DetaineeDetailsController < DetaineeController
  skip_before_action :redirect_unless_document_editable, only: %i[new create]

  def new
    form = Forms::DetaineeDetails.new(Detainee.new(prison_number: params[:prison_number]))
    form.validate flash[:form_data] if flash[:form_data]

    render :show, locals: { form: form, submit_path: detainee_path }
  end

  def create
    form = Forms::DetaineeDetails.new(Detainee.new)
    if form.validate(params[:detainee_details])
      form.save
      redirect_to new_move_path(form.model.id)
    else
      flash[:form_data] = params[:detainee_details]
      redirect_to new_detainee_path
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

  def redirect_to_move_or_profile
    if active_move.present?
      redirect_to profile_path(active_move)
    elsif detainee.moves.any?
      redirect_to copy_move_path(detainee)
    else
      redirect_to new_move_path(detainee)
    end
  end

  def form
    @_form ||= Forms::DetaineeDetails.new(detainee)
  end
end
