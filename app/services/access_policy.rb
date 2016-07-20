module AccessPolicy
  module_function

  def edit?(escort:)
    not DocumentWorkflow.new(escort).is_issued?
  end

  def print?(escort:)
    escort.move.complete?
  end
end
