# frozen_string_literal: true

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
    return if can? :update, escort

    redirect_back(fallback_location: root_path, alert: t('alerts.escort.edit.unauthorized'))
  end

  def authenticate_user!
    redirect_to new_session_path unless sso_identity
  end

  def authorize_admin!
    return if current_user && current_user.admin?

    flash[:error] = t('alerts.admin.access.unauthorized')
    redirect_to root_path
  end

  def authorize_prison_officer!
    return if AuthorizeUserToAccessPrisoner.call(current_user, prison_number)

    establishments = current_user.authorized_establishments.map(&:name).join(' or ')
    flash[:error] = t('alerts.detainee.access.unauthorized', establishments: establishments)
    redirect_to(root_path)
  end

  def authorize_user_to_access_escort!
    return if can? :read, escort

    flash[:error] = t('alerts.escort.access.unauthorized')
    redirect_to root_path
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
