module RiskAssessment
  class SexOffencesSection < BaseSection
    def name
      'sex_offences'
    end

    def questions
      %w[sex_offence_adult_male_victim sex_offence_adult_female_victim
         sex_offence_under18_victim]
    end

    def mandatory_questions
      %w[sex_offence]
    end

    private

    def question_dependencies
      {
        sex_offence: %i[sex_offence_adult_male_victim sex_offence_adult_female_victim
                        sex_offence_under18_victim]
      }
    end
  end
end
