class MoveInformationController < MoveController
  before_action :add_destination, only: [:update]

  def show
    if flash[:form_data]
      form.validate flash[:form_data]
    else
      form.prepopulate!
    end
    render locals: { form: form, submit_path: move_information_path(active_move) }
  end

  def update
    if form.validate(params[:information])
      form.save
      redirect_to profile_detainee_path(detainee)
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
      render :show, locals: { form: form, submit_path: move_information_path(move) }
    end
  end
end
