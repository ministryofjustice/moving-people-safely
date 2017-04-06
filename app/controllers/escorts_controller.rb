class EscortsController < ApplicationController
  helper_method :escort

  def create
    escort = EscortCreator.call(escort_params)
    if escort.move
      redirect_to edit_escort_move_path(escort.id)
    else
      redirect_to new_escort_detainee_path(escort.id, escort_params)
    end
  end

  def show
    @escort = Escort.find(params[:id])
  end

  private

  attr_reader :escort

  def escort_params
    params.require(:escort).permit(:prison_number)
  end
end
