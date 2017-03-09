module Moves
  class PrintController < ApplicationController
    def show
      error_redirect && return unless printable_move?
      issue_move_unless_issued!
      pdf = PdfGenerator.new(move).call
      send_data pdf, type: 'application/pdf', disposition: 'inline'
    end

    private

    def move
      @_move ||= Move.find(params[:move_id])
    end

    def issue_move_unless_issued!
      move.move_workflow.issued! unless move.issued?
    end

    def printable_move?
      move.complete? || move.issued?
    end

    def error_redirect
      redirect_back(fallback_location: root_path, alert: t('alerts.move.print.unauthorized'))
    end
  end
end
