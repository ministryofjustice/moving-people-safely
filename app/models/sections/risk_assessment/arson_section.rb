module RiskAssessment
  class ArsonSection
    def name
      'arson'
    end

    def questions
      %w[arson damage_to_property]
    end
    alias mandatory_questions questions
  end
end
