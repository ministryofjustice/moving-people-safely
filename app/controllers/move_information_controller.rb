class MoveInformationController < MoveController
  before_action :add_destination, only: [:update]
  skip_before_action :redirect_unless_document_editable, only: %i[ new copy ]

  def new
    detainee = Detainee.find(params[:detainee_id])
    fail if detainee.active_move.present?
    form = Forms::Moves::Information.new(detainee.build_move)
    form.prepopulate!
    render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee) }
  end

  def copy
    detainee = Detainee.find(params[:detainee_id])
    fail if detainee.active_move.present? || detainee.moves.none?
    form = Forms::Moves::Information.new(detainee.moves.most_recent.copy_without_saving)
    render 'move_information/show', locals: { form: form, submit_path: create_move_path(detainee) }
  end

  def show
    if params[:form_data]
      form.validate params[:form_data]
    else
      form.prepopulate!
    end
    render locals: { form: form, submit_path: move_information_url(active_move) }
  end

  def create
    if form.validate(params[:information])
      form.save
      redirect_to profile_path(active_move)
    else
      flash[:form_data] = params[:information]
      redirect_to new_move_path(detainee)
    end
  end

  def update
    if form.validate(params[:information])
      form.save
      redirect_to profile_path(move)
    else
      flash[:form_data] = params[:information]
      redirect_to move_information_path(move)
    end
  end

  private

  def form
    @_form ||= Forms::Moves::Information.new(move)
  end

  def add_destination
    if params.key? 'move_add_destination'
      form.deserialize params[:information]
      form.add_destination
      render :show, locals: { form: form }
    end
  end
end
