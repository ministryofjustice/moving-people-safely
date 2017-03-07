module Print
  class AssessmentQuestionPresenter < SimpleDelegator
    include Print::Helpers

    delegate :name, :depends_on, :section, to: :question

    attr_reader :question

    def initialize(question, assessment)
      super(assessment)
      @question = question
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
        question.relevant_answer?(value)
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
        question.relevant_answer?(value) ? highlighted_content(answer) : answer
      end
    end

    def details
      return default_details unless question.has_details?
      question.details.each_with_object([]) do |detail_attr, details|
        if detail_attr.is_a?(Hash)
          details << complex_detail_context(detail_attr)
        elsif public_send(detail_attr).present?
          details << detail_content(detail_attr)
        end
      end.join('. ')
    end

    private

    def default_details
      public_send("#{name}_details") if respond_to?("#{name}_details")
    end

    def detail_content(attribute)
      [detail_label(attribute), answer_value(public_send(attribute))].join('')
    end

    def complex_detail_context(hash)
      public_send(hash[:collection]).each_with_object([]) do |item, details|
        details << hash[:fields].map do |field|
          [
            detail_label("#{hash[:collection]}_collection.#{field}"),
            answer_value(item.send(field))
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

    def section_name
      section.name
    end
  end
end
