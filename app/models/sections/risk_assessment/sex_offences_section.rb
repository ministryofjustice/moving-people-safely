module RiskAssessment
  class SexOffencesSection < BaseSection
    def name
      'sex_offences'
    end

    def questions
      %w[sex_offence]
    end
    alias mandatory_questions questions
  end
end
