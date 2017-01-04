module Summary
  class HealthcarePresenter < AssessmentSectionPresenter
    private

    def section
      @section ||= HealthcareAssessment.section_for(section_name)
    end
  end
end
