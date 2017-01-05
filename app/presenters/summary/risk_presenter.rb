module Summary
  class RiskPresenter < AssessmentSectionPresenter
    private

    def section
      @section ||= RiskAssessment.section_for(section_name)
    end
  end
end
