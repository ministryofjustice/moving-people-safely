module Print
  class AssessmentQuestionPresenter < SimpleDelegator
    include PresenterHelpers

    def label
      content = t("print.section.questions.#{section_name}.#{name}")
      if relevant_answer?
        strong_title_label(content)
      else
        title_label(content)
      end
    end

    def dependency_questions
      model.dependency_questions.map do |question|
        self.class.new(question)
      end
    end

    def answer
      case value
      when 'no', false
        'No'
      when 'yes', true
        highlighted_content('Yes')
      else
        answer = answer_value(value)
        relevant_answer? ? highlighted_content(answer) : answer
      end
    end

    def details
      return unless has_dependencies?
      dependency_questions.each_with_object([]) do |subquestion, output|
        output << (subquestion.complex? ? complex_detail_context(subquestion) : detail_content(subquestion.name))
      end.join(' | ')
    end

    private

    def detail_content(attribute)
      label = detail_label(attribute)
      value = answer_value(public_send(attribute))

      value = 'No date available' if label == 'Last incident: ' && value.blank?

      [label, value].join('')
    end

    def complex_detail_context(question)
      public_send(question.name).each_with_object([]) do |item, output|
        output << question.subquestions.map do |subquestion|
          [
            detail_label("#{question.name}_collection.#{subquestion.name}"),
            answer_value(item.send(subquestion.name))
          ].join(' ')
        end.join(' | ')
      end.join('</br>')
    end

    def detail_label(attribute)
      t(attribute, scope: [:print, :section, :questions, section_name], raise: true)
    rescue
      nil
    end

    def answer_value(value)
      default_value = value.respond_to?(:humanize) ? value.humanize : value
      return nil if default_value.blank?
      t(value, scope: [:print, :section, :answers, section_name], default: default_value)
    end

    def model
      __getobj__
    end
  end
end
