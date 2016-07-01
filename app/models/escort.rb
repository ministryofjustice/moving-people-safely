class Escort < ApplicationRecord
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offenses, dependent: :destroy

  def self.find_detainee_by_prison_number(number)
    joins(:detainee).where(detainees: { prison_number: number }).first
  end

  delegate :prison_number, :surname, :forenames, :date_of_birth,
    to: :detainee, allow_nil: true, prefix: true

  delegate :date, :to, to: :move, allow_nil: true, prefix: true

  def move
    super || build_move
  end

  def healthcare
    super || build_healthcare
  end

  def offenses
    super || build_offenses
  end
end
