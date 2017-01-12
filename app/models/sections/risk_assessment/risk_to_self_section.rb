module RiskAssessment
  class RiskToSelfSection < BaseSection
    def name
      'risk_to_self'
    end

    def questions
      %w[acct_status]
    end
    alias mandatory_questions questions

    def questions_details
      {
        acct_status: %i[date_of_most_recently_closed_acct acct_status_details]
      }
    end
  end
end
