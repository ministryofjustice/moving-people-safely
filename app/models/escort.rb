class Escort < ApplicationRecord
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences, dependent: :destroy
  has_one :risks, dependent: :destroy

  def self.find_detainee_by_prison_number(number)
    joins(:detainee).where(detainees: { prison_number: number }).first
  end

  def move
    super || build_move
  end

  def healthcare
    super || build_healthcare
  end

  def offences
    super || build_offences
  end

  def risks
    super || build_risks
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
