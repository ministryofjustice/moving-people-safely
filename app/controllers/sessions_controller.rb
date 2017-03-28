class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def create
    identity = SSO::Identity.from_omniauth(auth_hash)

    if identity
      session[:sso_data] = identity.to_h
    else
      flash[:notice] = t('.cannot_sign_in')
    end
    redirect_to root_path
  end

  def destroy
    redirect_to logout_url
  ensure
    reset_session
  end

  private

  def auth_hash
    @auth_hash ||= request.env['omniauth.auth']
  end

  def sso_path
    '/auth/mojsso'
  end
  helper_method :sso_path

  def logout_url
    return root_url unless sso_identity
    url = URI.parse(sso_identity.logout_url)
    url.query = { redirect_to: root_url }.to_query
    url.to_s
  end
end
