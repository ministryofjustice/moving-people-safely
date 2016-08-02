module AccessPolicy
  module_function

  def edit?(move:)
    !move.workflow.issued?
  end

  def print?(move:)
    move.complete?
  end
end
