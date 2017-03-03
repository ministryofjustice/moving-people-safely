module Print
  class AssessmentQuestionPresenter < SimpleDelegator
    include Print::Helpers

    delegate :question_is_conditional?, :question_condition, to: :section
    delegate :question_has_details?, :question_details, to: :section
    delegate :relevant_answer?, to: :section

    attr_reader :name

    def initialize(question, assessment, section)
      super(assessment)
      @name = question
      @section = section
    end

    def label
      content = t("summary.section.questions.#{section_name}.#{name}")
      if answer_is_relevant?
        strong_title_label(content)
      else
        title_label(content)
      end
    end

    def answer_is_relevant?
      return default_relevance unless question_is_conditional?(name)
      question_condition_answered_yes? && checkbox_checked?
    end

    def answer
      return default_answer unless question_is_conditional?(name)
      if question_condition_answered_yes? && checkbox_checked?
        highlighted_content('Yes')
      else
        'No'
      end
    end

    def details
      return default_details unless question_has_details?(name)
      question_details(name).each_with_object([]) do |detail_attr, details|
        if detail_attr.is_a?(Hash)
          details << complex_detail_context(detail_attr)
        elsif public_send(detail_attr).present?
          details << detail_content(detail_attr)
        end
      end.join('. ')
    end

    private

    attr_reader :section

    def default_relevance
      value = public_send(name)
      case value
      when 'no', false
        false
      when 'yes', true
        true
      else
        relevant_answer?(name, value)
      end
    end

    def default_answer
      value = public_send(name)
      case value
      when 'no', false
        'No'
      when 'yes', true
        highlighted_content('Yes')
      else
        answer = answer_value(value)
        relevant_answer?(name, value) ? highlighted_content(answer) : answer
      end
    end

    def default_details
      public_send("#{name}_details") if respond_to?("#{name}_details")
    end

    def question_condition_answered_yes?
      public_send(question_condition(name)) == 'yes'
    end

    def checkbox_checked?
      public_send(name) == true
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
      I18n.t!(attribute, scope: [:summary, :section, :questions, section_name])
    rescue
      nil
    end

    def answer_value(value)
      default_value = value.respond_to?(:humanize) ? value.humanize : value
      I18n.t(value, scope: [:summary, :section, :answers, section_name], default: default_value)
    end

    def section_name
      section.name
    end
  end
end
