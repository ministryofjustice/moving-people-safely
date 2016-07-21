class DocumentController < ApplicationController
  before_action :redirect_unless_document_editable

  helper_method :escort, :offences, :risk, :healthcare, :detainee, :move

  def move
    escort.move
  end

  def detainee
    escort.detainee
  end

  def offences
    escort.offences
  end

  def risk
    escort.risk
  end

  def healthcare
    escort.healthcare
  end

  def escort
    @escort ||= Escort.find(params[:escort_id])
  end

  private

  def redirect_unless_document_editable
    unless AccessPolicy.edit?(escort: escort)
      redirect_back(fallback_location: root_path)
    end
  end
end
