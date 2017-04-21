module RiskAssessment
  class ArsonSection < BaseSection
    def name
      'arson'
    end

    def questions
      %w[arson]
    end
    alias mandatory_questions questions
  end
end
