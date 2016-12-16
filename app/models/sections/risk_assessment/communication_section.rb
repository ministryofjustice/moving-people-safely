module RiskAssessment
  class CommunicationSection < BaseSection
    def name
      'communication'
    end

    def questions
      %w[interpreter_required hearing_speach_sight can_read_and_write]
    end
    alias mandatory_questions questions
  end
end
