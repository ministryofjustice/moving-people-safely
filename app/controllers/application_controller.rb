class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private

  def redirect_unless_detainee_exists
    redirect_to escort_path(escort) unless escort.detainee.present?
  end

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(escort: escort)
      redirect_back(fallback_location: root_path, alert: t('alerts.escort.edit.unauthorized'))
    end
  end

  def authenticate_user!
    redirect_to new_session_path unless sso_identity
  end

  def authorize_user_to_access_prisoner!
    unless AuthorizeUserToAccessPrisoner.call(current_user, prison_number)
      flash[:error] = t('alerts.detainee.access.unauthorized', prison_number: prison_number)
      redirect_to(root_path)
    end
  end

  def authorize_user_to_access_escort!
    unless AuthorizeUserToAccessEscort.call(current_user, escort)
      flash[:error] = t('alerts.detainee.access.unauthorized', prison_number: escort.prison_number)
      redirect_to(root_path)
    end
  end

  def current_user
    @current_user ||= sso_identity&.user
  end
  helper_method :current_user

  def user_signed_in?
    sso_identity.present?
  end
  helper_method :user_signed_in?

  def sso_identity
    @sso_identity ||= set_sso_identity
  end

  def set_sso_identity
    session[:sso_data] && SSO::Identity.from_session(session[:sso_data])
  end
end
