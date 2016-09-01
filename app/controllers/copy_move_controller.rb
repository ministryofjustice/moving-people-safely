class CopyMoveController < DetaineeController
  before_action :redirect_unless_detainee_has_previously_issued_move, only: [:copy]
  skip_before_action :redirect_unless_document_editable

  def copy
    move = detainee.most_recent_move.copy_without_saving
    if flash[:form_data]
      move.assign_attributes(flash[:form_data])
      move.valid?
    end
    render 'move_information/show', locals: { move: move, submit_path: copy_move_create_path(detainee) }
  end

  def create
    move = detainee.moves.build
    move.assign_attributes permitted_params
    if move.valid?
      move.save_copy
      redirect_to profile_path(active_move)
    else
      flash[:form_data] = permitted_params
      redirect_to copy_move_path(detainee)
    end
  end

  private

  def permitted_params
    params.require(:move).permit(
      :reason,
      :reason_details,
      :date,
      :from,
      :to
    )
  end

  def redirect_unless_detainee_has_previously_issued_move
    if detainee.active_move.present? || detainee.moves.none?
      redirect_back(fallback_location: root_path) && return
    end
  end
end
