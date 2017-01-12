module Summary
  class AssessmentSubsectionPresenter < AssessmentSectionPresenter
    attr_reader :section_name, :subsection_name
    alias name subsection_name

    def self.for(subsection, section, assessment)
      new(assessment, section: section, subsection: subsection)
    end

    def initialize(object, options = {})
      super(object, section: options.fetch(:section))
      @section_name = options.fetch(:section)
      @subsection_name = options.fetch(:subsection)
    end

    def questions
      questions_for_subsection(subsection_name)
    end
  end
end
