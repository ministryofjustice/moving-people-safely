class NewMoveController < DetaineeController
  before_action :add_destination, only: [:create]
  skip_before_action :redirect_unless_document_editable

  def new
    detainee = Detainee.find(params[:detainee_id])
    fail if detainee.active_move.present?
    form = Forms::Moves::Information.new(detainee.moves.build)
    form.prepopulate!
    render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee) }
  end

  def copy
    detainee = Detainee.find(params[:detainee_id])
    fail if detainee.active_move.present? || detainee.moves.none?
    form = Forms::Moves::Information.new(detainee.moves.most_recent.copy_without_saving)
    render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee) }
  end

  def create
    form = Forms::Moves::Information.new(detainee.moves.build)
    if form.validate(params[:information])
      form.save
      redirect_to profile_path(active_move)
    else
      flash[:form_data] = params[:information]
      redirect_to new_move_path(detainee)
    end
  end

  private

  def add_destination
    form = Forms::Moves::Information.new(detainee.moves.build)
    if params.key? 'move_add_destination'
      form.deserialize params[:information]
      form.add_destination
      render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee)}
    end
  end
end
