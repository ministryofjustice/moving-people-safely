module HealthcareAssessment
  class ContactSection < BaseSection
    def name
      'contact'
    end

    def questions
      %w[healthcare_professional contact_number]
    end
    alias mandatory_questions questions
  end
end
