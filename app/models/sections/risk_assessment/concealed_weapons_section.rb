module RiskAssessment
  class ConcealedWeaponsSection
    def name
      'concealed_weapons'
    end

    def questions
      %w[conceals_weapons]
    end
    alias mandatory_questions questions
  end
end
