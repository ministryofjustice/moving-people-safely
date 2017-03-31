class OffencesController < DetaineeController
  before_action :add_offence, only: [:update]

  def show
    prepopulate_current_offences
    form.validate(flash[:form_data]) if flash[:form_data]
    form.prepopulate!
    render locals: { form: form }
  end

  def update
    if form.validate form_data
      form.save
      active_move.offences_workflow.confirm_with_user!(user: current_user)
      redirect_to detainee_path(detainee)
    else
      flash[:form_data] = form_data
      redirect_to offences_path(detainee)
    end
  end

  private

  def add_offence
    if params.key? 'offences_add_offence'
      form.deserialize form_data
      form.add_current_offence
      render :show, locals: { form: form }
    end
  end

  def form_data
    params.require(:offences)
  end

  def form
    @_form ||= Forms::Offences.new(offences)
  end

  private(*delegate(:current_offences, to: :offences))

  def prepopulate_current_offences
    current_offences.blank? && current_offences.build(fetch_offences)
  end

  def fetch_offences
    Detainees::OffencesFetcher.new(detainee.prison_number).call.data.map(&:attributes)
  end
end
