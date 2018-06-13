class EscortsController < ApplicationController
  helper_method :escort

  before_action :redirect_if_missing_data, only: :show
  before_action :authorize_prison_officer!, only: :create
  before_action :authorize_user_to_access_escort!, except: :create

  def create
    escort = EscortCreator.call(escort_params)
    escort.create_move(from_establishment: current_user.establishment(session))
    EscortPopulator.new(escort).call if escort.from_prison?
    if escort.detainee
      redirect_to edit_escort_detainee_path(escort)
    else
      redirect_to new_escort_detainee_path(escort, escort_params)
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
    params.require(:escort).permit(:prison_number, :pnc_number, :cancelling_reason)
  end

  def redirect_if_missing_data
    valid_move = Forms::Move.new(escort.move).prepopulate!.valid?
    redirect_to(new_escort_detainee_path(escort)) && return unless escort.detainee
    redirect_to(edit_escort_move_path(escort)) && return unless valid_move
  end
end
