module HealthcareAssessment
  class TransportSection < BaseSection
    def name
      'transport'
    end

    def questions
      %w[mpv]
    end
    alias mandatory_questions questions
  end
end
