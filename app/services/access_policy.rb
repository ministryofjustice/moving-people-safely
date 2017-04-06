module AccessPolicy
  module_function

  def edit?(escort:)
    escort && !escort.issued?
  end

  def print?(escort:)
    escort&.completed?
  end
end
