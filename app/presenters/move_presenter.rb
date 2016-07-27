class MovePresenter < SimpleDelegator
  def humanized_date
    date && date.to_s(:humanized)
  end

  def humanized_reason
    if reason == 'other'
      reason_details
    else
      reason.humanize
    end
  end

  def must_return_to
    destinations.must_return_to.map(&:establishment).join(', ')
  end

  def must_not_return_to
    destinations.must_not_return_to.map(&:establishment).join(', ')
  end
end
