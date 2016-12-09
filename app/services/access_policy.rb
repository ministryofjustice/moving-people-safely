module AccessPolicy
  module_function

  def edit?(move:)
    move && move.active?
  end

  def print?(move:)
    move.complete?
  end
end
