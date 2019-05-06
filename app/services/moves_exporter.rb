# frozen_string_literal: true

require 'csv'

class MovesExporter
  DETAINEE_ATTRIBUTES = %i[prison_number surname forenames date_of_birth gender ethnicity].freeze
  ESTABLISHMENT_ATTRIBUTES = %i[name type].freeze
  MOVE_ATTRIBUTES = %i[to to_type date].freeze
  SCHEDULED_MOVE_ATTRIBUTES = %i[violent suicide self_harm escape_risk segregation medical].freeze

  ALL_ATTRIBUTES = DETAINEE_ATTRIBUTES + ESTABLISHMENT_ATTRIBUTES + MOVE_ATTRIBUTES + SCHEDULED_MOVE_ATTRIBUTES

  def self.call
    moves = ScheduledMove.includes(escort: [{ move: [:from_establishment] }, :detainee, :risk, :healthcare, :offences])

    CSV.generate(headers: true) do |csv|
      csv << ALL_ATTRIBUTES

      moves.each do |scheduled_move|
        escort = scheduled_move.escort
        move = escort.move

        csv <<
          DETAINEE_ATTRIBUTES.map { |attr| escort.detainee.send(attr) } +
          ESTABLISHMENT_ATTRIBUTES.map { |attr| move.from_establishment.send(attr) } +
          MOVE_ATTRIBUTES.map { |attr| move.send(attr) } +
          SCHEDULED_MOVE_ATTRIBUTES.map { |attr| scheduled_move.send(attr) }
      end
    end
  end
end
