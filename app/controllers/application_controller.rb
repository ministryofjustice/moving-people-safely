class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :offences,
    :risk,
    :healthcare,
    :detainee,
    :active_move,
    :healthcare_workflow,
    :risk_workflow,
    :offences_workflow

  delegate :risk, :healthcare, :offences, :active_move, to: :detainee
  delegate :healthcare_workflow, :risk_workflow, :offences_workflow, to: :active_move

  private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(move: active_move)
      redirect_back(fallback_location: root_path)
    end
  end

  def authenticate_user!
    if session[:user_id].blank?
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  helper_method :current_user

  def user_signed_in?
    session[:user_id].present?
  end
  helper_method :user_signed_in?
end
