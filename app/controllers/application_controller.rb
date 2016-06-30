class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :escort
  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def render_cell(*cell_attrs)
    render html: cell(*cell_attrs), layout: true
  end
end
