class Detainee < ApplicationRecord
  belongs_to :escort

  def active_move
    escort.move
    # move.active.take(1)
  end

  def healthcare
    escort.healthcare
  end

  def risk
    escort.risk
  end

  def offences
    escort.offences
  end
end
