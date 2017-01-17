module RiskAssessment
  class SecuritySection < BaseSection
    def name
      'security'
    end

    def questions
      %w[current_e_risk prison_escape_attempt court_escape_attempt
         police_escape_attempt other_type_escape_attempt category_a
         escort_risk_assessment escape_pack]
    end

    def mandatory_questions
      %w[current_e_risk previous_escape_attempts category_a
         escort_risk_assessment escape_pack]
    end

    private

    def question_dependencies
      {
        previous_escape_attempts: %i[prison_escape_attempt court_escape_attempt
                                     police_escape_attempt other_type_escape_attempt]
      }
    end

    def questions_details
      {
        current_e_risk: %i[current_e_risk_details],
        escort_risk_assessment: %i[escort_risk_assessment_completion_date],
        escape_pack: %i[escape_pack_completion_date]
      }
    end

    def subsections_questions
      {
        escape_status: %w[current_e_risk],
        previous_escape_attempts: %w[prison_escape_attempt court_escape_attempt
                                     police_escape_attempt other_type_escape_attempt],
        category_a: %w[category_a],
        escort_details: %w[escort_risk_assessment escape_pack]
      }
    end
  end
end
