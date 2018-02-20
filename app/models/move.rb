class Move < ApplicationRecord
  belongs_to :escort
  belongs_to :from_establishment, class_name: 'Establishment'

  def alerts
    { not_for_release: (not_for_release == 'yes') }
  end
end
