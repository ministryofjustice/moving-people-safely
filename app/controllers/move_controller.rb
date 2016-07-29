class MoveController < ApplicationController
  before_action :redirect_unless_document_editable

  delegate :risk, :healthcare, :offences, :detainee, :move, to: :escort

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  def detainee
    escort.detainee
  end
end
