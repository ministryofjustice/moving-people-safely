module RiskAssessment
  class HarassmentsSection
    def name
      'harassments'
    end

    def questions
      %w[hostage_taker stalker harasser intimidator bully]
    end

    def mandatory_questions
      %w[stalker_harasser_bully]
    end
  end
end
