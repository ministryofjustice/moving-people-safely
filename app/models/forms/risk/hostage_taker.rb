module Forms
  module Risk
    class HostageTaker < Forms::Base
      optional_field :hostage_taker, default: 'unknown'
      optional_checkbox :staff_hostage_taker
      optional_checkbox :prisoners_hostage_taker
      optional_checkbox :public_hostage_taker

      reset attributes: %i[
        staff_hostage_taker date_most_recent_staff_hostage_taker_incident
        prisoners_hostage_taker date_most_recent_prisoners_hostage_taker_incident
        public_hostage_taker date_most_recent_public_hostage_taker_incident
      ], if_falsey: :hostage_taker

      property :date_most_recent_staff_hostage_taker_incident, type: TextDate
      reset attributes: %i[date_most_recent_staff_hostage_taker_incident],
            if_falsey: :staff_hostage_taker,
            enabled_value: true

      validates :date_most_recent_staff_hostage_taker_incident,
        date: { not_in_the_future: true },
        if: -> { staff_hostage_taker == true }

      property :date_most_recent_prisoners_hostage_taker_incident, type: TextDate
      reset attributes: %i[date_most_recent_prisoners_hostage_taker_incident],
            if_falsey: :prisoners_hostage_taker,
            enabled_value: true

      validates :date_most_recent_prisoners_hostage_taker_incident,
        date: { not_in_the_future: true },
        if: -> { prisoners_hostage_taker == true }

      property :date_most_recent_public_hostage_taker_incident, type: TextDate
      reset attributes: %i[date_most_recent_public_hostage_taker_incident],
            if_falsey: :public_hostage_taker,
            enabled_value: true

      validates :date_most_recent_public_hostage_taker_incident,
        date: { not_in_the_future: true },
        if: -> { public_hostage_taker == true }
    end
  end
end
