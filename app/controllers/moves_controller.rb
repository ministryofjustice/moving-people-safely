class MovesController < ApplicationController
  before_action :redirect_unless_document_editable
  before_action :redirect_if_move_already_exists, only: %i[new create]
  helper_method :escort, :from_establishment

  def new
    form = Forms::Move.new(escort.build_move)
    render locals: { form: form }
  end

  def create
    form = Forms::Move.new(escort.build_move)

    if form.validate(params[:move])
      form.save
      set_establishment
      redirect_to escort_path(escort)
    else
      render :new, locals: { form: form }
    end
  end

  def edit
    form = Forms::Move.new(move)
    render locals: { form: form }
  end

  def update
    form = Forms::Move.new(move)

    if form.validate(params[:move])
      form.save
      redirect_to escort_path(escort)
    else
      render :edit, locals: { form: form }
    end
  end

  private

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def move
    escort.move || raise(ActiveRecord::RecordNotFound)
  end

  def set_establishment
    move.update from_establishment: user_or_prisoner_establishment
  end

  def from_establishment
    move.from_establishment || user_or_prisoner_establishment
  end

  def user_or_prisoner_establishment
    return current_user.authorized_establishments.first if current_user.authorized_establishments.one?
    response = Detainees::LocationFetcher.new(escort.prison_number).call
    Establishment.find_by!(nomis_id: response.to_h[:code])
  end

  def redirect_if_move_already_exists
    redirect_to escort_path(escort), alert: t('alerts.escort.move.exists') if escort.move
  end
end
