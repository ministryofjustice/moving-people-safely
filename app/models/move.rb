class Move < ApplicationRecord
  belongs_to :escort
  belongs_to :from_establishment, class_name: 'Establishment'

  def active_alerts
    alerts = []
    alerts << :not_for_release if not_for_release == 'yes'
    alerts
  end
end
