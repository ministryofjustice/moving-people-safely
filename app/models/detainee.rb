class Detainee < ApplicationRecord
  belongs_to :escort

  def active_move
    moves.workflow.not.issued.take(1)
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
