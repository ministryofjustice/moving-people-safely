class EscortsController < ApplicationController
  helper_method :escort

  before_action :redirect_if_missing_data, only: :show
  before_action :authorize_user_to_access_prisoner!, only: :create
  before_action :authorize_user_to_read_escort!, only: :show
  before_action :authorize_user_to_update_escort!, except: %i[create show]

  def create
    escort = EscortCreator.call(escort_params)
    if escort.detainee
      redirect_to edit_escort_detainee_path(escort.id)
    else
      redirect_to new_escort_detainee_path(escort.id, escort_params)
    end
  end

  def confirm_cancel
    @form = Forms::Escort.new(escort)
  end

  def cancel
    @form = Forms::Escort.new(escort)
    if @form.validate(escort_params)
      escort.cancel!(current_user, escort_params[:cancelling_reason])
      redirect_to root_path
    else
      render :confirm_cancel
    end
  end

  private

  def prison_number
    escort_params[:prison_number]
  end

  def escort
    @escort ||= Escort.find(params[:id])
  end

  def escort_params
    params.require(:escort).permit(:prison_number, :cancelling_reason)
  end

  def redirect_if_missing_data
    redirect_to(new_escort_detainee_path(escort)) && return unless escort.detainee
    redirect_to(new_escort_move_path(escort)) && return unless escort.move
  end
end
