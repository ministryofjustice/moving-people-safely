class OffencesController < DetaineeController
  before_action :add_offence, only: [:update]

  def show
    prepopulate_offences
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
      form.add_offence
      render :show, locals: { form: form }
    end
  end

  def form_data
    params.require(:offences)
  end

  def form
    @_form ||= Forms::Offences.new(detainee)
  end

  private(*delegate(:offences, to: :detainee))

  def prepopulate_offences
    offences.blank? && offences.build(fetch_offences)
  end

  def fetch_offences
    result = Detainees::OffencesFetcher.new(detainee.prison_number).call
    flash_fetcher_error(result.error) if result.error.present?
    result.data.map(&:attributes)
  end

  def flash_fetcher_error(error)
    flash.now[:warning] ||= []
    flash.now[:warning] << t("alerts.offences.#{error}")
  end
end
