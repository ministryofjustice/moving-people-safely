module Escorts
  class PrintController < ApplicationController
    def new
      escort
    end

    def show
      escort.update issued_at: nil
      error_redirect && return unless printable_escort?
      issue_escort_unless_issued!
      data = open(escort.document_path)
      send_data data.read, type: 'application/pdf', disposition: 'inline'
    end

    private

    def escort
      @escort ||= Escort.find(params[:escort_id])
    end

    def issue_escort_unless_issued!
      EscortIssuer.call(escort) unless escort.issued?
    end

    def printable_escort?
      escort.completed? || escort.issued?
    end

    def error_redirect(message = t('alerts.escort.print.unauthorized'))
      redirect_back(fallback_location: root_path, alert: message)
    end
  end
end
