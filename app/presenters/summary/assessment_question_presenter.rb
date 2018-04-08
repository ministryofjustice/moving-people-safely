module Summary
  class AssessmentQuestionPresenter < SimpleDelegator
    include PresenterHelpers

    def label
      t("summary.section.questions.#{section_name}.#{name}")
    end

    def answer
      return parent_based_answer(parent_group_answer) if belongs_to_group?
      return parent_based_answer(parent.value) if parent&.is_question?
      format_answered_value
    end

    def details
      return unless has_dependencies?
      dependency_questions.each_with_object([]) do |dependency, output|
        if dependency.complex?
          output << complex_detail_context(dependency)
        elsif public_send(dependency.name).present?
          output << detail_content(dependency.name)
        end
      end.join(' | ')
    end

    private

    def parent_based_answer(parent_value)
      case parent_value
      when nil
        error_content('Missing')
      when 'no', false
        boolean? ? 'No' : 'None'
      else
        format_answered_value
      end
    end

    def format_answered_value
      case value
      when nil
        error_content('Missing')
      when 'no', false
        'No'
      when 'yes', true
        highlight('Yes')
      else
        answer = answer_value(value)
        relevant_answer? ? highlight(answer) : answer
      end
    end

    def detail_content(attribute)
      [detail_label(attribute), answer_value(public_send(attribute))].join('')
    end

    def complex_detail_context(question)
      public_send(question.name).each_with_object([]) do |item, output|
        output << '<p>'
        output << question.subquestions.map do |subquestion|
          [
            '<b>',
            detail_label("#{question.name}_collection.#{subquestion.name}"),
            answer_value(item.send(subquestion.name)),
            '</b>'
          ].join(' ')
        end.join(' | ')
        output << '</p>'
      end.join
    end

    def detail_label(attribute)
      scope = [:summary, :section, :questions, section_name]
      t(attribute, scope: scope, raise: true)
    rescue
      nil
    end

    def answer_value(value)
      return '' if value.blank?
      default_value = value.respond_to?(:humanize) ? sanitize(value.humanize) : value
      t(value, scope: [:summary, :section, :answers, section_name], default: default_value)
    end

    def highlight(text)
      "<b>#{text}</b>"
    end

    def error_content(text)
      "<span class='text-error'>#{text}</span>"
    end
  end
end
