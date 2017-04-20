module Escorts
  class PrintController < ApplicationController
    def show
      error_redirect && return unless printable_escort?
      issue_escort_unless_issued!
      pdf = PdfGenerator.new(escort).call
      send_data pdf, type: 'application/pdf', disposition: 'inline'
    end

    private

    def escort
      @escort = Escort.find(params[:escort_id])
    end

    def issue_escort_unless_issued!
      escort.issue! unless escort.issued?
    end

    def printable_escort?
      escort.completed? || escort.issued?
    end

    def error_redirect
      redirect_back(fallback_location: root_path, alert: t('alerts.escort.print.unauthorized'))
    end
  end
end
