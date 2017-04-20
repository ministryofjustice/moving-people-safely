class EscortCompletionValidator
  def self.call(escort)
    new(escort).call
  end

  def initialize(escort)
    @escort = escort
  end

  def call
    valid_detainee? && valid_move? && completed?
  end

  private

  attr_reader :escort

  delegate :detainee, :move, to: :escort

  def valid_detainee?
    detainee && Forms::Detainee.new(detainee).valid?
  end

  def valid_move?
    move && Forms::Move.new(move).valid?
  end

  def completed?
    move && move.complete?
  end
end
