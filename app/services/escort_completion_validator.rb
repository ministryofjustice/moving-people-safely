class EscortCompletionValidator < SimpleDelegator
  def self.call(escort)
    new(escort).call
  end

  def call
    valid_detainee? && valid_move? &&
      valid_assessments? && completed?
  end

  private

  def valid_detainee?
    detainee && Forms::Detainee.new(detainee).valid?
  end

  def valid_move?
    move && Forms::Move.new(move).valid?
  end

  def valid_assessments?
    risk_complete? && healthcare_complete? && offences_complete?
  end

  def completed?
    move && move.complete?
  end
end
