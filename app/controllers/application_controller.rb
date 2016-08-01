class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :offences,
    :risk,
    :healthcare,
    :detainee,
    :move,
    :escort,
    :active_move,
    :healthcare_workflow,
    :risk_workflow,
    :offences_workflow

  delegate :risk, :healthcare, :offences, :active_move, to: :detainee
  delegate :move, to: :escort
  delegate :healthcare_workflow, :risk_workflow, :offences_workflow, to: :active_move

  private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(escort: escort)
      redirect_back(fallback_location: root_path)
    end
  end
end
