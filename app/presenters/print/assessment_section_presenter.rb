module Print
  class AssessmentSectionPresenter < SimpleDelegator
    include PresenterHelpers

    def questions
      @questions ||= model.questions.map do |question|
        Print::AssessmentQuestionPresenter.new(question)
      end
    end

    def relevant
      relevant? ? highlighted_content('Yes') : 'No'
    end

    def label
      content = t("print.section.titles.#{name}")
      relevant? ? highlighted_content(content) : content
    end

    private

    def relevant?
      questions.any?(&:answer_is_relevant?)
    end

    def model
      __getobj__
    end
  end
end
