class Detainee < ApplicationRecord
  belongs_to :escort

  def healthcare
    escort.healthcare
  end

  def risk
    escort.risk
  end

  def offences
    escort.offences
  end

  def moves
    Move.joins('escort').joins('detainee').where('detainee.prison_number = ?', prison_number)
  end
end
