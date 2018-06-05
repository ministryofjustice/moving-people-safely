class MovesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :set_establishment
  helper_method :escort, :form

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
    @form ||= Forms::Move.new(escort)
  end

  def set_establishment
    escort.update(from_establishment: user_or_prisoner_establishment) unless escort.from_establishment
  end

  def user_or_prisoner_establishment
    establishment = current_user.establishment(session)
    return establishment if establishment
    response = Detainees::LocationFetcher.new(escort.prison_number).call
    Establishment.find_by!(nomis_id: response.to_h[:code])
  end
end
