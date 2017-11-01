class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  private

  def court_user?
    current_user.court?
  end

  def redirect_to_court_view
    redirect_to court_path
  end

  def redirect_unless_detainee_exists
    redirect_to escort_path(escort) unless escort.detainee.present?
  end

  def redirect_unless_document_editable
    unless can? :update, escort
      redirect_back(fallback_location: root_path, alert: t('alerts.escort.edit.unauthorized'))
    end
  end

  def authenticate_user!
    redirect_to new_session_path unless sso_identity
  end

  def authorize_user_to_access_prisoner!
    unless AuthorizeUserToAccessPrisoner.call(current_user, prison_number)
      establishments = current_user.authorized_establishments.map(&:name).join(' or ')
      flash[:error] = t('alerts.detainee.access.unauthorized', establishments: establishments)
      redirect_to(root_path)
    end
  end

  def authorize_user_to_read_escort!
    unless can? :read, escort
      flash[:error] = t('alerts.escort.access.unauthorized')
      redirect_to root_path
    end
  end

  def authorize_user_to_update_escort!
    unless can? :update, escort
      flash[:error] = t('alerts.escort.access.unauthorized')
      redirect_to escort_path(escort)
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
