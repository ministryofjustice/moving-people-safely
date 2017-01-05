module HealthcareAssessment
  class NeedsSection < BaseSection
    def name
      'needs'
    end

    def questions
      %w[dependencies has_medications]
    end
    alias mandatory_questions questions
  end
end
