module Forms
  module Risk
    class RiskToSelf < Forms::Base
      ACCT_STATUSES = %w[open post_closure closed none].freeze
      ACCT_STATUS_WITH_DETAILS = 'closed'.freeze

      options_field :acct_status, options: :acct_statuses, if: :from_prison?

      property :acct_status_details, type: StrictString
      validates :acct_status_details,
        presence: true,
        if: -> { acct_status == ACCT_STATUS_WITH_DETAILS }

      property :date_of_most_recently_closed_acct, type: TextDate
      validates :date_of_most_recently_closed_acct,
        date: { not_in_the_future: true },
        if: -> { acct_status == ACCT_STATUS_WITH_DETAILS }

      reset attributes: %i[acct_status_details date_of_most_recently_closed_acct],
            if_falsey: :acct_status,
            enabled_value: ACCT_STATUS_WITH_DETAILS

      options_field_with_details :self_harm

      OBSERVATION_LEVELS = %w[level1 level2 level3 level4].freeze
      OBSERVATION_LEVELS_REQUIRING_DETAILS = %w[level2 level3 level4].freeze

      options_field :observation_level, options: :observation_levels, if: :from_police?

      property :observation_level2_details, type: StrictString
      validates :observation_level2_details,
        presence: true, if: -> { observation_level == 'level2' }

      property :observation_level3_details, type: StrictString
      validates :observation_level3_details,
        presence: true, if: -> { observation_level == 'level3' }

      property :observation_level4_details, type: StrictString
      validates :observation_level4_details,
        presence: true, if: -> { observation_level == 'level4' }

      def acct_statuses
        ACCT_STATUSES
      end

      def acct_status_with_details
        ACCT_STATUS_WITH_DETAILS
      end

      def observation_levels
        OBSERVATION_LEVELS
      end

      def observation_levels_requiring_details
        OBSERVATION_LEVELS_REQUIRING_DETAILS
      end
    end
  end
end
