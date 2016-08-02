module AccessPolicy
  module_function

  def edit?(move:)
    move && move.workflow.active?
  end

  def print?(move:)
    move.complete?
  end
end
