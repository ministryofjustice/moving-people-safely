module AccessPolicy
  module_function

  def edit?(escort:)
    escort && escort.editable?
  end

  def print?(escort:)
    escort&.completed?
  end
end
