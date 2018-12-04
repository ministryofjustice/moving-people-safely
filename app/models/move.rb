# frozen_string_literal: true

class Move < ApplicationRecord
  belongs_to :escort
  belongs_to :from_establishment, class_name: 'Establishment'

  delegate :editable?, :location, to: :escort

  def alerts
    {
      not_for_release: (not_for_release == 'yes'),
      travelling_with_child: (travelling_with_child == 'yes')
    }
  end

  def from_prison?
    from_establishment&.type == 'Prison'
  end

  def from_police?
    from_establishment&.type == 'PoliceCustody'
  end
end
