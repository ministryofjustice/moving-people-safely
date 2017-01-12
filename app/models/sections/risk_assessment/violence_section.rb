module RiskAssessment
  class ViolenceSection < BaseSection
    def name
      'violence'
    end

    def questions
      %w[risk_to_females homophobic racist other_violence_due_to_discrimination
         violence_to_staff_custody violence_to_staff_community co_defendant
         gang_member other_violence_to_other_detainees violence_to_general_public]
    end

    def mandatory_questions
      %w[violence_due_to_discrimination violence_to_staff violence_to_other_detainees violence_to_general_public]
    end

    private

    def question_dependencies
      {
        violence_due_to_discrimination: %i[risk_to_females homophobic racist other_violence_due_to_discrimination],
        violence_to_staff: %i[violence_to_staff_custody violence_to_staff_community],
        violence_to_other_detainees: %i[co_defendant gang_member other_violence_to_other_detainees]
      }
    end

    def subsections_questions
      {
        discrimination: %w[risk_to_females homophobic racist other_violence_due_to_discrimination],
        violence_to_staff: %w[violence_to_staff_custody violence_to_staff_community],
        violence_to_other_detainees: %w[co_defendant gang_member other_violence_to_other_detainees],
        violence_to_general_public: %w[violence_to_general_public]
      }
    end
  end
end
