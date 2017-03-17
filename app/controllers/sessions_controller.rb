class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def create
    session[:user_id] = User.from_omniauth(auth_hash).id
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

  private

  def auth_hash
    @auth_hash ||= request.env['omniauth.auth']
  end

  def sso_path
    '/auth/mojsso'
  end
  helper_method :sso_path
end
