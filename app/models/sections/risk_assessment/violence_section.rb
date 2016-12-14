module RiskAssessment
  class ViolenceSection
    def name
      'violence'
    end

    def questions
      %w[risk_to_females homophobic racist other_violence_due_to_discrimination
         violence_to_staff_custody violence_to_staff_community co_defendant
         gang_member other_violence_to_other_detainees violence_to_general_public]
    end

    def question_is_conditional?(question)
      !question_condition(question).nil?
    end

    def question_condition(question)
      question_dependencies.select { |_scope, dependencies| dependencies.include?(question.to_sym) }.keys.first
    end

    private

    def question_dependencies
      {
        violence_due_to_discrimination: %i[risk_to_females homophobic racist other_violence_due_to_discrimination],
        violence_to_staff: %i[violence_to_staff_custody violence_to_staff_community],
        violence_to_other_detainees: %i[co_defendant gang_member other_violence_to_other_detainees]
      }
    end
  end
end
