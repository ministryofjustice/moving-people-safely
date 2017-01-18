module HealthcareAssessment
  class NeedsSection < BaseSection
    def name
      'needs'
    end

    def questions
      %w[dependencies has_medications]
    end
    alias mandatory_questions questions

    private

    def questions_details
      {
        has_medications:
        [
          {
            collection: :medications,
            fields: %i[description administration carrier]
          }
        ]
      }
    end
  end
end
