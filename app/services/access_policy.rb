module AccessPolicy
  module_function

  def print?(escort:)
    escort.move.complete?
  end
end
