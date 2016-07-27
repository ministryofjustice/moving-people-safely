module AccessPolicy
  module_function

  def clone_escort?(escort:)
    !escort.with_future_move? && escort.with_move?
  end

  def edit?(escort:)
    !DocumentWorkflow.new(escort).is_issued?
  end

  def print?(escort:)
    escort.move.complete?
  end
end
