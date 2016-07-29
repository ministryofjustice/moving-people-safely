class DocumentController < ApplicationController
  before_action :redirect_unless_document_editable

  helper_method :escort, :offences, :risk, :healthcare, :detainee, :move

  delegate :risk, :healthcare, :offences, to: :detainee

  def move
    escort.move
  end

  def escort
    @escort ||= if params[:escort_id]
      Escort.find(params[:escort_id])
      else
        detainee.escort
      end
  end

  def detainee
    @_detainee ||= if params[:detainee_id]
      Detainee.find(params[:detainee_id])
    else
      escort.detainee
    end
  end

  private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(escort: escort)
      redirect_back(fallback_location: root_path)
    end
  end
end
