module HealthcareAssessment
  class ContactSection < BaseSection
    def name
      'contact'
    end

    def questions
      %w[healthcare_professional contact_number]
    end
    alias mandatory_questions questions

    def relevant_answers
      {
        healthcare_professional: :all,
        contact_number: :all
      }
    end
  end
end
