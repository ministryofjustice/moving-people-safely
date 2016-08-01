class DetaineeController < ApplicationController
  before_action :redirect_unless_document_editable

  def escort
    detainee.active_move
  end

  def detainee
    @_detainee ||= Detainee.find(params[:detainee_id])
  end
end
