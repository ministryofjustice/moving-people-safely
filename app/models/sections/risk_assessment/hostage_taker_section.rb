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
  end
end
