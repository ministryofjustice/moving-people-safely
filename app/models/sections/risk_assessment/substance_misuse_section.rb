module RiskAssessment
  class SubstanceMisuseSection < BaseSection
    def name
      'substance_misuse'
    end

    def questions
      %w[substance_supply]
    end
    alias mandatory_questions questions
  end
end
