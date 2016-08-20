class Detainee < ApplicationRecord
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences, dependent: :destroy
  has_many :moves, dependent: :destroy

  def initialize(*)
    super
    build_healthcare
    build_risk
    build_offences
  end

  def active_move
    moves.active.first
  end

  def most_recent_move
    moves.present? && moves.order_by_recentness.first
  end

  def age
    (Date.today - date_of_birth).to_i / 365
  end

  def each_alias
    aliases.split(',').each { |a| yield a }
  end
end
