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
end
