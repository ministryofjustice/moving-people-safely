module RiskAssessment
  class HarassmentsSection < BaseSection
    def name
      'harassments'
    end

    def questions
      %w[harassment intimidation_to_staff intimidation_to_public
         intimidation_to_other_detainees intimidation_to_witnesses]
    end

    def mandatory_questions
      %w[harassment intimidation]
    end

    private

    def question_dependencies
      {
        intimidation: %i[intimidation_to_staff intimidation_to_public
                         intimidation_to_other_detainees intimidation_to_witnesses]
      }
    end

    def subsections_questions
      {
        harassment: %w[harassment],
        intimidation: %w[intimidation_to_staff intimidation_to_public
                         intimidation_to_other_detainees intimidation_to_witnesses]
      }
    end
  end
end
