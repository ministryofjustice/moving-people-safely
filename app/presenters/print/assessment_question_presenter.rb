module Print
  class AssessmentQuestionPresenter < SimpleDelegator
    include Print::Helpers

    delegate :name, to: :question

    attr_reader :question, :section

    def initialize(question, assessment, section)
      super(assessment)
      @question = question
      @section = section
    end

    def label
      content = t("print.section.questions.#{section_name}.#{name}")
      if answer_is_relevant?
        strong_title_label(content)
      else
        title_label(content)
      end
    end

    def answer_is_relevant?
      value = public_send(name)
      case value
      when 'no', false
        false
      when 'yes', true
        true
      else
        return answer_schema.relevant? if answer_schema
        question.string? && value.present?
      end
    end

    def answer_requires_group_questions?
      group_questions.present?
    end

    def group_questions
      return [] unless answer_schema
      answer_schema.group_questions.map do |question|
        self.class.new(question, __getobj__, section)
      end
    end

    def answer
      value = public_send(name)
      case value
      when 'no', false
        'No'
      when 'yes', true
        highlighted_content('Yes')
      else
        answer = answer_value(value)
        answer_schema&.relevant? ? highlighted_content(answer) : answer
      end
    end

    def has_details?
      answer_schema&.has_dependencies?
    end

    def details
      return unless has_details?
      answer_schema.questions.each_with_object([]) do |subquestion, output|
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

    def answer_schema
      value = public_send(name)
      question.answer_for(value)
    end

    def answer_value(value)
      default_value = value.respond_to?(:humanize) ? value.humanize : value
      I18n.t(value, scope: [:print, :section, :answers, section_name], default: default_value)
    end

    def section_name
      section.name
    end
  end
end
