module RiskAssessment
  class ConcealedWeaponsSection < BaseSection
    def name
      'concealed_weapons'
    end

    def questions
      %w[conceals_weapons conceals_drugs conceals_mobile_phones
         conceals_sim_cards conceals_other_items]
    end

    def mandatory_questions
      %w[conceals_weapons conceals_drugs conceals_mobile_phone_or_other_items]
    end

    private

    def question_dependencies
      {
        conceals_mobile_phone_or_other_items: %i[
          conceals_mobile_phones conceals_sim_cards conceals_other_items
        ]
      }
    end
  end
end
