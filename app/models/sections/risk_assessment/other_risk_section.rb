module RiskAssessment
  class OtherRiskSection < BaseSection
    def name
      'other_risk'
    end

    def questions
      %w[other_risk]
    end
    alias mandatory_questions questions
  end
end
