module HealthcareAssessment
  class CommunicationSection < BaseSection
    def name
      'communication'
    end

    def questions
      %w[hearing_speech_sight_issues reading_writing_issues]
    end
    alias mandatory_questions questions
  end
end
