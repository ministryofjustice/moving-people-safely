class NewMoveController < DetaineeController
  before_action :redirect_if_detainee_has_active_move, only: [:new]
  skip_before_action :redirect_unless_document_editable

  def new
    move = detainee.moves.build
    move.assign_attributes flash[:form_data] if flash[:form_data]
    render 'move_information/show', locals: { move: move, submit_path: create_move_path(detainee) }
  end

  def create
    move = detainee.moves.build
    move.assign_attributes permitted_params
    if move.save
      redirect_to profile_path(move)
    else
      flash[:form_data] = permitted_params
      redirect_to new_move_path(detainee)
    end
  end

  private

  def permitted_params
    params.require(:move).permit(:from, :to, :reason, :reason_details, :date)
  end

  def redirect_if_detainee_has_active_move
    if detainee.active_move.present?
      redirect_back(fallback_location: root_path) && return
    end
  end
end
