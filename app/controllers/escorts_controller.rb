class EscortsController < ApplicationController
  helper_method :escort
  before_action :redirect_if_missing_data, only: :show

  def create
    escort = EscortCreator.call(escort_params)
    if escort.move
      redirect_to edit_escort_move_path(escort.id)
    elsif escort.detainee
      redirect_to new_escort_move_path(escort)
    else
      redirect_to new_escort_detainee_path(escort.id, escort_params)
    end
  end

  def show
  end

  private

  def escort
    @escort ||= Escort.find(params[:id])
  end

  def escort_params
    params.require(:escort).permit(:prison_number)
  end

  def redirect_if_missing_data
    redirect_to(new_escort_detainee_path(escort)) && return unless escort.detainee
    redirect_to(new_escort_move_path(escort)) && return unless escort.move
  end
end
