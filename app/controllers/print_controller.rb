class PrintController < MoveController
  def show
    error_redirect && return unless active_move.complete?
    active_move.workflow.issued!
    redirect_to root_path
  end

  private

  def error_redirect
    # TODO: error notification
    redirect_back(fallback_location: root_path)
  end
end
