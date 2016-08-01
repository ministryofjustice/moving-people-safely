module AccessPolicy
  module_function

  def clone_escort?(escort:)
    escort.detainee.active_move.nil?
  end

  def edit?(escort:)
    !escort.move.workflow.issued?
  end

  def print?(escort:)
    escort.move.complete?
  end
end
