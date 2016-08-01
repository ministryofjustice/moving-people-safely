class MoveController < ApplicationController
  before_action :redirect_unless_document_editable

  def move
    @_move ||= Move.find(params[:move_id])
  end

  def escort
    @escort ||= Move.find(params[:move_id])
  end

  def detainee
    escort.detainee
  end
end
