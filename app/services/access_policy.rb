module AccessPolicy
  module_function

  def edit?(escort:)
    escort.workflow_status != 'printed'
  end

  def print?(escort:)
    escort.move.complete?
  end
end
