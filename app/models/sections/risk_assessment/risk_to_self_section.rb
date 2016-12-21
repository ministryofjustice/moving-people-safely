module RiskAssessment
  class RiskToSelfSection < BaseSection
    def name
      'risk_to_self'
    end

    def questions
      %w[acct_status]
    end
    alias mandatory_questions questions
  end
end
