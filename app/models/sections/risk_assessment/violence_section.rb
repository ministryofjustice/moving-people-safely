module RiskAssessment
  class ViolenceSection
    def name
      'violence'
    end

    def questions
      %w[prison_staff risk_to_females escort_or_court_staff healthcare_staff
         other_detainees homophobic racist public_offence_related police]
    end
  end
end
