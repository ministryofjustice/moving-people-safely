class PrintController < MoveController
  layout false

  def show
    # error_redirect && return unless active_move.complete?
    # active_move.move_workflow.issued!
  end

  private

  def error_redirect
    # TODO: error notification
    redirect_back(fallback_location: root_path)
  end
end
