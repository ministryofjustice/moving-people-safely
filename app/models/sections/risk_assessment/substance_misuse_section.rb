module RiskAssessment
  class SubstanceMisuseSection < BaseSection
    def name
      'substance_misuse'
    end

    def questions
      %w[trafficking_drugs trafficking_alcohol]
    end

    def mandatory_questions
      %w[substance_supply]
    end

    private

    def question_dependencies
      {
        substance_supply: %i[trafficking_drugs trafficking_alcohol]
      }
    end
  end
end
