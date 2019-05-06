# frozen_string_literal: true

class ScheduledMovesController < ApplicationController
  def index
    send_data MovesExporter.call, filename: "scheduled-moves-#{Date.today}.csv"
  end
end
