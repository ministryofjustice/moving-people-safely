class MovesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :redirect_if_move_already_exists, only: %i[new create]
  helper_method :escort, :form, :from_establishment

  def create
    if form.validate(params[:move])
      form.save
      set_establishment
      redirect_to escort_path(escort)
    else
      render :new
    end
  end

  def update
    if form.validate(params[:move])
      form.save
      redirect_to escort_path(escort)
    else
      render :edit
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def form
    @form ||= Forms::Move.new(escort.move || escort.build_move)
  end

  def set_establishment
    escort.move.update from_establishment: user_or_prisoner_establishment
  end

  def from_establishment
    escort.move.from_establishment || user_or_prisoner_establishment
  end

  def user_or_prisoner_establishment
    establishment = current_user.establishment(session)
    return establishment if establishment
    response = Detainees::LocationFetcher.new(escort.prison_number).call
    Establishment.find_by!(nomis_id: response.to_h[:code])
  end

  def redirect_if_move_already_exists
    redirect_to escort_path(escort), alert: t('alerts.escort.move.exists') if escort.move
  end
end
