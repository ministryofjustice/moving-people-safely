module RiskAssessment
  class HostageTakerSection < BaseSection
    def name
      'hostage_taker'
    end

    def questions
      %w[staff_hostage_taker prisoners_hostage_taker public_hostage_taker]
    end

    def mandatory_questions
      %w[hostage_taker]
    end

    private

    def question_dependencies
      {
        hostage_taker: %i[staff_hostage_taker prisoners_hostage_taker public_hostage_taker]
      }
    end

    def questions_details
      {
        staff_hostage_taker: %i[date_most_recent_staff_hostage_taker_incident],
        prisoners_hostage_taker: %i[date_most_recent_prisoners_hostage_taker_incident],
        public_hostage_taker: %i[date_most_recent_public_hostage_taker_incident]
      }
    end
  end
end
