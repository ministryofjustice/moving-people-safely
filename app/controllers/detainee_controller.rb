class DetaineeController < ApplicationController
  before_action :redirect_unless_document_editable

  def escort
    detainee.escort
  end

  def detainee
    @_detainee ||= Detainee.find(params[:detainee_id])
  end
end
