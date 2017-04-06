class Escort < ApplicationRecord
  default_scope { order('created_at desc') }
  has_one :detainee
  has_one :move

  def risk
    detainee&.risk
  end

  def healthcare
    detainee&.healthcare
  end

  def offences
    detainee&.offences
  end

  def completed?
    EscortCompletionValidator.call(self)
  end

  def issued?
    move&.issued?
  end

  def issue!
    move.issued!
  end

  def needs_review!
    move.save_copy
  end

  def needs_review?
    risk.needs_review? ||
      healthcare.needs_review? ||
      offences.needs_review?
  end
end
