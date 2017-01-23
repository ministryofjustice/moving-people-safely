class NewMoveController < DetaineeController
  before_action :add_destination, only: [:create]
  before_action :redirect_if_detainee_has_active_move, only: [:new]
  skip_before_action :redirect_unless_document_editable

  def new
    form = Forms::Moves::Information.new(detainee.moves.build)
    if flash[:form_data]
      form.validate flash[:form_data]
    else
      form.prepopulate!
    end
    render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee) }
  end

  def create
    form = Forms::Moves::Information.new(detainee.moves.build)
    if form.validate(params[:information])
      form.save
      redirect_to detainee_path(detainee)
    else
      flash[:form_data] = params[:information]
      redirect_to new_move_path(detainee)
    end
  end

  private

  def redirect_if_detainee_has_active_move
    if detainee.active_move.present?
      redirect_back(fallback_location: root_path) && return
    end
  end

  def add_destination
    form = Forms::Moves::Information.new(detainee.moves.build)
    if params.key? 'move_add_destination'
      form.deserialize params[:information]
      form.add_destination
      render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee) }
    end
  end
end
