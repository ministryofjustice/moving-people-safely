class DetaineeDetailsController < DetaineeController
  skip_before_action :redirect_unless_document_editable,
  only: %i[ new create ]

  def new
    detainee = Detainee.new(prison_number: params[:prison_number])

    # just for User Testing purposes 9/8/2016
    if params[:prison_number].upcase == LENNIE_GODBER
      detainee.assign_attributes attributes_for_lennie_godber
    # end of testing code. TODO: delete me

    elsif flash[:form_data]
      detainee.assign_attributes flash[:form_data]
    end

    render :show,
    locals: { form: detainee, submit_path: detainee_path }
  end

  def create
    detainee = Detainee.new permitted_params
    if detainee.save
      redirect_to new_move_path(detainee.id)
    else
      flash[:form_data] = permitted_params
      redirect_to new_detainee_path
    end
  end

  def show
    detainee = Detainee.new
    detainee.assign_attributes(flash[:form_data]) if flash[:form_data]
    render :show, locals: { form: detainee, submit_path: detainee_details_path(detainee) }
  end

  def update
    detainee = Detainee.new permitted_params
    if detainee.save
      redirect_to_move_or_profile
    else
      flash[:form_data] = permitted_params
      redirect_to detainee_details_path(detainee)
    end
  end

  private

  def permitted_params
    params.require(:detainee).permit(
      :forenames,
      :surname,
      :date_of_birth,
      :gender,
      :nationalities,
      :pnc_number,
      :cro_number,
      :aliases,
      :prison_number
    )
  end

  def redirect_to_move_or_profile
    if active_move.present?
      redirect_to profile_path(active_move)
    elsif detainee.moves.any?
      redirect_to copy_move_path(detainee)
    else
      redirect_to new_move_path(detainee)
    end
  end
end
