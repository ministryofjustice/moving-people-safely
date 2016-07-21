class PrintController < ApplicationController
  rescue_from DocumentWorkflow::StateChangeError, with: :redirect_on_error

  def show
    # TODO: generate PDF
    DocumentWorkflow.new(escort).update_status!(:issued)
    # TODO: render PDF

    # TODO: remove me once the above is sorted
    redirect_to root_path, flash: { notice: 'Document Printed.' }
    # ========================================
  end

  private

  def redirect_on_error
    flash[:error] = 'Cannot print this document at this time.'
    redirect_back(fallback_location: root_path)
  end
end
