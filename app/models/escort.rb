class Escort < ApplicationRecord
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences, dependent: :destroy
  has_one :risk, dependent: :destroy

  def self.find_detainee_by_prison_number(number)
    joins(:detainee).where(detainees: { prison_number: number }).first
  end

  def self.create_with_children(prison_number:)
    new.tap do |escort|
      escort.build_detainee(prison_number: prison_number)
      escort.build_healthcare
      escort.build_offences
      escort.build_risk
      escort.save!
    end
  end

  def move
    super || build_move
  end

  def with_future_move?
    move.date && move.date > Date.current
  end

  def with_past_move?
    move.date && move.date <= Date.current
  end

  def with_move?
    with_future_move? || with_past_move?
  end
end
