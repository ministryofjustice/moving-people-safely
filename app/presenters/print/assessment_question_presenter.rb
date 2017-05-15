module Print
  class AssessmentQuestionPresenter < SimpleDelegator
    include PresenterHelpers

    def label
      content = t("print.section.questions.#{section_name}.#{name}")
      if answer_is_relevant?
        strong_title_label(content)
      else
        title_label(content)
      end
    end

    def answer_is_relevant?
      case value
      when 'no', false
        false
      when 'yes', true
        true
      else
        return relevant_answer? if answer_schema
        string? && value.present?
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
        if subquestion.complex?
          output << complex_detail_context(subquestion)
        elsif public_send(subquestion.name).present?
          output << detail_content(subquestion.name)
        end
      end.join('. ')
    end

    private

    def detail_content(attribute)
      [detail_label(attribute), answer_value(public_send(attribute))].join('')
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
      I18n.t!(attribute, scope: [:print, :section, :questions, section_name])
    rescue
      nil
    end

    def answer_value(value)
      default_value = value.respond_to?(:humanize) ? value.humanize : value
      I18n.t(value, scope: [:print, :section, :answers, section_name], default: default_value)
    end

    def model
      __getobj__
    end
  end
end
