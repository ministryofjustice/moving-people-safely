class MovePresenter < SimpleDelegator
  def humanized_date
    date.to_s(:humanized)
  end

  def humanized_reason
    if reason == 'other'
      reason_details
    else
      reason.humanize
    end
  end
end
