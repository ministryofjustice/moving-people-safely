class CopyMoveController < DetaineeController
  before_action :add_destination, only: [:create]
  before_action :redirect_unless_detainee_has_previously_issued_move, only: [:copy]
  skip_before_action :redirect_unless_document_editable

  def copy
    form = Forms::Move.new(detainee.most_recent_move.copy_without_saving)
    render :new, locals: { form: form }
  end

  def create
    form = Forms::Move.new(detainee.moves.build)
    if form.validate(params[:move])
      form.save_copy
      redirect_to detainee_path(detainee)
    else
      render :new, locals: { form: form }
    end
  end

  private

  def redirect_unless_detainee_has_previously_issued_move
    if detainee.active_move.present? || detainee.moves.none?
      redirect_back(fallback_location: root_path) && return
    end
  end

  def add_destination
    form = Forms::Move.new(detainee.moves.build)
    if params.key? 'move_add_destination'
      form.deserialize params[:move]
      form.add_destination
      render :new, locals: { form: form }
    end
  end
end
