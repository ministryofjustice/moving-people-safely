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
    if sso_identity
      logout_url = build_url(sso_identity.logout_url, root_url)
      redirect_to logout_url
    else
      redirect_to root_url
    end
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

  def build_url(url, redirect_url = nil)
    url = URI.parse(sso_identity.logout_url)
    url.query = { redirect_to: redirect_url }.to_query if redirect_url
    url.to_s
  end
end
