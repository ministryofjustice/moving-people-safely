class Detainee < ApplicationRecord
  belongs_to :escort
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences, dependent: :destroy
  has_many :moves, dependent: :destroy

  def active_move
    moves.active.first
  end

  def most_recent_move
    moves.present? && moves.order_by_recentness.first
  end
end
