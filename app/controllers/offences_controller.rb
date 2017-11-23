class OffencesController < ApplicationController
  before_action :redirect_unless_document_editable, except: :show
  before_action :add_offence, only: [:update]

  helper_method :escort, :offences, :offences_workflow

  def show
    prepopulate_offences if escort.editable?
    form.validate(flash[:form_data]) if flash[:form_data]
    form.prepopulate!
    render locals: { form: form }
  end

  def update
    if form.validate form_data
      form.save
      offences_workflow.confirm!(user: current_user)
      redirect_to escort_path(escort)
    else
      flash[:form_data] = form_data
      redirect_to escort_offences_path(escort)
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def offences
    escort.offences
  end

  def offences_workflow
    escort.offences_workflow || escort.build_offences_workflow
  end

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
    @_form ||= Forms::Offences.new(escort)
  end

  def prepopulate_offences
    nomis_offences = fetch_offences
    offences.clear.build(nomis_offences) if nomis_offences.any?
  end

  def fetch_offences
    result = Detainees::OffencesFetcher.new(escort.prison_number).call
    flash_fetcher_error(result.error) if result.error.present?
    result.data.map(&:attributes)
  end

  def flash_fetcher_error(error)
    flash.now[:warning] ||= []
    flash.now[:warning] << t("alerts.offences.#{error}")
  end
end
