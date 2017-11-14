class MovePresenter < SimpleDelegator
  include ActionView::Helpers::OutputSafetyHelper

  def humanized_date
    date && date.to_s(:humanized)
  end

  def from
    from_establishment&.name
  end

  def not_for_release_text
    text = not_for_release_reason.humanize
    text << " (#{not_for_release_reason_details})" if not_for_release_reason == 'other'
    text
  end
end
