module HealthcareAssessment
  class MentalSection < BaseSection
    def name
      'mental'
    end

    def questions
      %w[mental_illness phobias]
    end
    alias mandatory_questions questions
  end
end
