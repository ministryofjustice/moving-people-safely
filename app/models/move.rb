class Move < ApplicationRecord
  belongs_to :escort
  belongs_to :from_establishment, class_name: 'Establishment'

  def alerts
    { not_for_release: (not_for_release == 'yes') }
  end

  def not_for_release_text
    text = not_for_release_reason.humanize
    text << " (#{not_for_release_reason_details})" if not_for_release_reason == 'other'
    text
  end
end
