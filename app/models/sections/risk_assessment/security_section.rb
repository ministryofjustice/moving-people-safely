module RiskAssessment
  class SecuritySection < BaseSection
    def name
      'security'
    end

    def questions
      %w[current_e_risk category_a restricted_status escape_pack escape_risk_assessment cuffing_protocol]
    end

    def mandatory_questions
      %w[current_e_risk category_a restricted_status]
    end
  end
end
