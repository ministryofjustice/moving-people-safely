module HealthcareAssessment
  class AllergiesSection < BaseSection
    def name
      'allergies'
    end

    def questions
      %w[allergies]
    end
    alias mandatory_questions questions
  end
end
