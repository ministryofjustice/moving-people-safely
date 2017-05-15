module Summary
  class AssessmentSectionPresenter < SimpleDelegator
    include PresenterHelpers

    def label
      t("summary.section.titles.#{name}")
    end

    def questions
      model.questions.flat_map do |question|
        question.answer_requires_group_questions? ? question.dependency_questions : question
      end
    end

    private

    def model
      __getobj__
    end
  end
end
