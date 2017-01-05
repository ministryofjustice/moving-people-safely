module HealthcareAssessment
  class PhysicalSection < BaseSection
    def name
      'physical'
    end

    def questions
      %w[physical_issues]
    end
    alias mandatory_questions questions
  end
end
