class PrintController < ApplicationController
  rescue_from DocumentWorkflow::StateChangeError, with: :redirect_on_error

  def show
    DocumentWorkflow.new(escort).update_status!(:issued)
    redirect_to root_path
  end

  private

  def redirect_on_error
    # TODO: error notification
    redirect_back(fallback_location: root_path)
  end
end
