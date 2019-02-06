# frozen_string_literal: true

module Escorts
  class PrintController < ApplicationController
    include Auditable

    def new
      escort
    end

    def show
      error_redirect && return unless printable_escort?
      issue_escort_unless_issued!
      data = escort.document.download

      send_data data,
        type: 'application/pdf',
        disposition: 'inline',
        filename: escort.pdf_filename
    end

    private

    def escort
      @escort ||= Escort.find(params[:escort_id])
    end

    def issue_escort_unless_issued!
      if escort.issued?
        audit_print('re-print')
      else
        EscortIssuer.call(escort)
        audit_print('print')
      end
    end

    def audit_print(action)
      audit(escort, current_user, action)
    end

    def printable_escort?
      escort.completed? || escort.issued?
    end

    def error_redirect(message = t('alerts.escort.print.unauthorized'))
      audit(escort, current_user, 'attempted print but not printable')
      redirect_back(fallback_location: root_path, alert: message)
    end
  end
end
