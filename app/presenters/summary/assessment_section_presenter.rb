module Summary
  class AssessmentSectionPresenter < SimpleDelegator
    include PresenterHelpers

    def label
      t("summary.section.titles.#{name}")
    end

    def questions
      model.questions.flat_map do |question|
        question.group_questions.present? ? question.group_questions : question
      end
    end

    private

    def model
      __getobj__
    end
  end
end
