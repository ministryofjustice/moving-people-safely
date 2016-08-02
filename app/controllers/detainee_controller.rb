class DetaineeController < ApplicationController
  before_action :redirect_unless_document_editable

  def detainee
    @_detainee ||= Detainee.find(params[:detainee_id])
  end
end
