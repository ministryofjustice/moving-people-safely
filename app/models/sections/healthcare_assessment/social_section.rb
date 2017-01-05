module HealthcareAssessment
  class SocialSection < BaseSection
    def name
      'social'
    end

    def questions
      %w[personal_hygiene personal_care]
    end
    alias mandatory_questions questions
  end
end
