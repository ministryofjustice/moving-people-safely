class MoveController < ApplicationController
  before_action :redirect_unless_document_editable

  def move
    @_move ||= Move.find(params[:move_id])
  end
  alias active_move move

  def detainee
    move.detainee
  end
end
