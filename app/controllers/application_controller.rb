class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :escort, :offences, :risk, :healthcare, :detainee, :move

  private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(escort: escort)
      redirect_back(fallback_location: root_path)
    end
  end
end
