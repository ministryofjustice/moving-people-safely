require 'consideration'

class Detainee < ApplicationRecord
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences, dependent: :destroy
  has_many :moves, dependent: :destroy
  has_many :considerations, dependent: :destroy

  GENDERS = %w[ male female ]

  validates :surname, :forenames, presence: true

  validates :gender,
    inclusion: { in: GENDERS },
    allow_blank: true

  def genders
    GENDERS
  end

  def offences
    Considerations::FormFactory.new(self).(:offences)
  end

  def risk
    Considerations::FormFactory.new(self).(:risk)
  end

  def healthcare
    Considerations::FormFactory.new(self).(:healthcare)
  end

  def find_consideration_by_name(name)
    considerations.find_by_name(name)
  end

  def active_move
    moves.active.first
  end

  def most_recent_move
    moves.present? && moves.order_by_recentness.first
  end

  def age
    AgeCalculator.age(date_of_birth)
  end

  def each_alias
    aliases.split(',').each { |a| yield a }
  end
end
