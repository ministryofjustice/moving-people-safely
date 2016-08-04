class CopyMoveController < DetaineeController
  before_action :add_destination, only: [:create]
  before_action :redirect_unless_detainee_has_previously_issued_move, only: [:copy]
  skip_before_action :redirect_unless_document_editable

  def copy
    form = Forms::Moves::Information.new(detainee.most_recent_move.copy_without_saving)
    form.validate(flash[:form_data]) if flash[:form_data]
    render 'move_information/show', locals: { form: form, submit_path: copy_move_create_path(detainee) }
  end

  def create
    form = Forms::Moves::Information.new(detainee.moves.build)
    if form.validate(params[:information])
      form.save_copy
      redirect_to profile_path(active_move)
    else
      flash[:form_data] = params[:information]
      redirect_to copy_move_path(detainee)
    end
  end

  private

  def redirect_unless_detainee_has_previously_issued_move
    if detainee.active_move.present? || detainee.moves.none?
      redirect_back(fallback_location: root_path) && return
    end
  end

  def add_destination
    form = Forms::Moves::Information.new(detainee.moves.build)
    if params.key? 'move_add_destination'
      form.deserialize params[:information]
      form.add_destination
      render 'move_information/show', locals: { form: form, submit_path: copy_move_create_path(detainee) }
    end
  end
end
