class MoveInformationController < MoveController
  before_action :add_destination, only: [:update]

  def show
    move.assign_attributes flash[:form_data] if flash[:form_data]
    render locals: { form: move, submit_path: move_information_path(active_move) }
  end

  def update
    move.assign_attributes permitted_params
    if move.save
      redirect_to profile_path(move)
    else
      flash[:form_data] = params[:information]
      redirect_to move_information_path(move)
    end
  end

  private

  def permitted_params
    params.require(:move).permit(:from, :to, :reason, :reason_details, :date)
  end

  def add_destination
    if params.key? 'move_add_destination'
      form.deserialize params[:information]
      form.add_destination
      render :show, locals: { form: form, submit_path: move_information_path(move) }
    end
  end
end
