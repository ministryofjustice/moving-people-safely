# frozen_string_literal: true

class EscortsController < ApplicationController
  helper_method :escort

  include Auditable

  before_action :redirect_if_missing_data, only: :show
  before_action :authorize_prison_officer!, only: :create
  before_action :authorize_user_to_access_escort!, except: :create

  def show
    audit(escort, current_user, 'view')
  end

  def create
    escort = EscortCreator.call(escort_params, current_user.establishment(session))
    EscortPopulator.new(escort).call if escort.from_prison?
    if escort.detainee
      redirect_to edit_escort_detainee_path(escort)
    else
      redirect_to new_escort_detainee_path(escort, escort_params)
    end
  end

  def confirm_cancel
    @form = Forms::Escort.new
  end

  def cancel
    @form = Forms::Escort.new(escort_params)
    if @form.validate(escort_params)
      escort.cancel!(current_user, escort_params[:cancelling_reason])
      redirect_to root_path
    else
      render :confirm_cancel
    end
  end

  def approve
    escort.approve!(current_user) if current_user.sergeant?
    redirect_to root_path
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
    return unless escort.editable?

    check_for_detainee(escort) || return
    check_valid_detainee(escort.detainee) || return
    check_valid_move(escort.move) || return
  end

  def check_for_detainee(escort)
    if escort.detainee
      true
    else
      redirect_to(new_escort_detainee_path(escort)) && return
    end
  end

  def check_valid_detainee(detainee)
    if Forms::Detainee.new(detainee).prepopulate!.valid?
      true
    else
      redirect_to(edit_escort_detainee_path(escort)) && return
    end
  end

  def check_valid_move(move)
    if Forms::Move.new(move).prepopulate!.valid?
      true
    else
      redirect_to(edit_escort_move_path(escort)) && return
    end
  end
end
