module RiskAssessment
  class RiskFromOthersSection < BaseSection
    def name
      'risk_from_others'
    end

    def questions
      %w[rule_45 csra victim_of_abuse high_profile]
    end
    alias mandatory_questions questions

    private

    def relevant_answers
      {
        csra: %w[high]
      }
    end
  end
end
