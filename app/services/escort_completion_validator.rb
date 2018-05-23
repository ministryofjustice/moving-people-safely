class EscortCompletionValidator < SimpleDelegator
  def self.call(escort)
    new(escort).call
  end

  def call
    valid_detainee? && valid_move? && valid_assessments?
  end

  private

  def valid_detainee?
    Forms::Detainee.new(self).valid?
  end

  def valid_move?
    Forms::Move.form_for(self).prepopulate!.valid?
  end

  def valid_assessments?
    risk_complete? && healthcare_complete? && offences_complete?
  end
end
