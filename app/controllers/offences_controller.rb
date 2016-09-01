class OffencesController < DetaineeController
  before_action :add_offence, only: [:update]

  def show
    if flash[:form_data]
      form.assign_attributes flash[:form_data]
      form.validate
    end
    render locals: { form: form }
  end

  def update
    form.assign_attributes permitted_params
    if form.valid?
      form.save!
      active_move.offences_workflow.confirm_with_user!(user: current_user)
      redirect_to profile_path(active_move)
    else
      flash[:form_data] = permitted_params
      redirect_to offences_path(detainee)
    end
  end

  def confirm
    fail unless form.all_questions_answered?
    offences_workflow.confirm_with_user!(user: current_user)
    redirect_to profile_path(active_move)
  end

  private

  def add_offence
    if params.key?('add_offence') || params.key?('add_past_offence')
      form.assign_attributes permitted_params
      if params.key? 'add_offence'
        form.current_offences.prepopulate
      elsif params.key? 'add_past_offence'
        form.past_offences.prepopulate
      end
      flash[:form_data] = form.to_params
      redirect_to offences_path(detainee)
    end
  end

  def permitted_params
    form.models.map(&:name).inject({}) do |acc, name|
      acc[name] = params.require(name).permit!.to_h
      acc
    end
  end

  def form
    @_form ||= Considerations::FormFactory.new(detainee).(:offences)
  end
end
