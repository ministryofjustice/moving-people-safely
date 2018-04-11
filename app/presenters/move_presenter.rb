class MovePresenter < SimpleDelegator
  include ActionView::Helpers::OutputSafetyHelper

  def humanized_date
    date&.to_s(:humanized)
  end

  def from
    from_establishment&.name
  end

  def not_for_release_text
    return 'Contact the prison to confirm release' if not_for_release == 'no'
    return not_for_release_reason_details.humanize if not_for_release_reason == 'other'
    not_for_release_reason.humanize
  end
end
