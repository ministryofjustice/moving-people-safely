module Forms
  module Risk
    class RiskToSelf < Forms::Base
      ACCT_STATUS_WITH_DETAILS = 'closed'.freeze
      ACCT_STATUSES = %w[open post_closure closed none].freeze

      property_with_details :acct_status,
        type: StrictString,
        options: ACCT_STATUSES,
        option_with_details: ACCT_STATUS_WITH_DETAILS

      property :date_of_most_recently_closed_acct, type: TextDate
      reset attributes: %i[date_of_most_recently_closed_acct],
            if_falsey: :acct_status,
            enabled_value: ACCT_STATUS_WITH_DETAILS

      validates :date_of_most_recently_closed_acct,
        date: { not_in_the_future: true },
        if: -> { acct_status == ACCT_STATUS_WITH_DETAILS }

      property_with_details :self_harm

      def acct_statuses
        ACCT_STATUSES
      end

      def acct_status_with_details
        ACCT_STATUS_WITH_DETAILS
      end
    end
  end
end