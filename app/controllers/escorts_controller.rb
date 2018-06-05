class EscortsController < ApplicationController
  before_action :redirect_if_missing_data, only: :show
  before_action :authorize_prison_officer!, only: :create
  before_action :authorize_user_to_access_escort!, except: :create

  helper_method :escort

  def create
    escort = EscortCreator.call(escort_params)
    EscortPopulator.new(escort).call
    redirect_to edit_escort_detainee_path(escort.id)
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
    params.require(:escort).permit(:prison_number, :pnc_number, :cancelling_reason)
  end

  def redirect_if_missing_data
    valid_detainee = Forms::Detainee.new(escort).valid?
    valid_move = Forms::Move.new(escort).prepopulate!.valid?
    redirect_to(edit_escort_detainee_path(escort)) && return unless valid_detainee
    redirect_to(edit_escort_move_path(escort)) && return unless valid_move
  end
end
