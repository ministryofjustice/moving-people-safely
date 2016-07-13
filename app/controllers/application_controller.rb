class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :escort, :offences, :risks, :healthcare, :detainee, :move

  def move
    escort.move
  end

  def detainee
    escort.detainee
  end

  def offences
    escort.offences
  end

  def risks
    escort.risks
  end

  def healthcare
    escort.healthcare
  end

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end
end
