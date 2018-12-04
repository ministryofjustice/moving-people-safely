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
      data = open(escort.document_path)

      send_data data.read,
        type: 'application/pdf',
        disposition: 'inline',
        filename: pdf_filename(escort)
    end

    private

    def pdf_filename(escort)
      [
        'per',
        escort.detainee_surname&.dasherize,
        escort.detainee_forenames&.dasherize,
        escort.issued_at&.to_date&.to_s(:db)
      ].join('-') + '.pdf'
    end

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
