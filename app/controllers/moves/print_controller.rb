module Moves
  class PrintController < ApplicationController
    layout false

    def show
      error_redirect && return unless printable_move?
      move.move_workflow.issued! unless move.issued?
      render :show, locals: { detainee: detainee_presenter, move: move_presenter }
    end

    private

    def move
      @_move ||= Move.find(params[:move_id])
    end

    def detainee
      move.detainee
    end

    def printable_move?
      move.complete? || move.issued?
    end

    def error_redirect
      redirect_back(fallback_location: root_path, alert: t('alerts.move.print.unauthorized'))
    end

    def detainee_presenter
      @detainee_presenter ||= Print::DetaineePresenter.new(detainee)
    end

    def move_presenter
      @move_presenter ||= Print::MovePresenter.new(move)
    end
  end
end
