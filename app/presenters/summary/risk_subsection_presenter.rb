module Summary
  class RiskSubsectionPresenter < AssessmentSubsectionPresenter
    private

    def section
      @section ||= RiskAssessment.section_for(section_name)
    end
  end
end
