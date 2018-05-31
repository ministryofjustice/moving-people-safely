class Move < ApplicationRecord
  belongs_to :escort
  belongs_to :from_establishment, class_name: 'Establishment'

  def alerts
    { not_for_release: (not_for_release == 'yes') }
  end

  def from_prison?
    from_establishment&.type == 'Prison'
  end

  def from_police?
    from_establishment&.type == 'PoliceCustody'
  end
end
