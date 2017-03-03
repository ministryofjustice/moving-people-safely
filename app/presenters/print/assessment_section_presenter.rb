module Print
  class AssessmentSectionPresenter < SimpleDelegator
    include Print::Helpers

    attr_reader :section_name
    delegate :name, to: :section
    delegate :subsections, :has_subsections?, :questions_for_subsection, to: :section

    def self.for(section, assessment)
      new(assessment, section: section)
    end

    def initialize(object, options = {})
      super(object)
      @section_name = options.fetch(:section)
    end

    def questions
      @questions ||= section.questions.map do |question|
        Print::AssessmentQuestionPresenter.new(question, assessment, section)
      end
    end

    def relevant
      relevant? ? highlighted_content('Yes') : 'No'
    end

    def label
      content = t("summary.section.titles.#{name}")
      relevant? ? highlighted_content(content) : content
    end

    private

    def relevant?
      questions.any?(&:answer_is_relevant?)
    end

    def assessment
      __getobj__
    end
  end
end
