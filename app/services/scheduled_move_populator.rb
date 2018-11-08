# frozen_string_literal: true

class ScheduledMovePopulator
  def initialize(escort)
    @escort = escort
  end

  def call
    response = Detainees::ScheduledMoveFetcher.new(escort.prison_number).call
    return unless response.to_h.present?

    escort.scheduled_move&.destroy
    escort.create_scheduled_move(response.to_h)
  end

  def self.call(escort)
    new(escort).call
  end

  private

  attr_reader :escort
end
