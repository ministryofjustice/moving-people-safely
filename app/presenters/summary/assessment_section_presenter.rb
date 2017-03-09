module Summary
  class AssessmentSectionPresenter < SummaryPresenter
    attr_reader :section_name
    delegate :name, :questions, to: :section
    delegate :question_is_conditional?, :question_condition, to: :section
    delegate :question_has_details?, :question_details, to: :section
    delegate :subsections, :has_subsections?, :questions_for_subsection, to: :section
    delegate :relevant_answer?, to: :section

    def self.for(section, assessment)
      new(assessment, section: section)
    end

    def initialize(object, options = {})
      super(object)
      @section_name = options.fetch(:section)
    end

    def answer_for(attribute)
      return default_answer(attribute) unless question_is_conditional?(attribute)
      if question_condition_unanswered?(attribute)
        "<span class='text-error'>Missing</span>"
      elsif question_condition_answered_yes?(attribute) && checkbox_checked?(attribute)
        '<b>Yes</b>'
      else
        'No'
      end
    end

    def details_for(attribute)
      return super(attribute) unless question_has_details?(attribute)
      question_details(attribute).each_with_object([]) do |detail_attr, details|
        if detail_attr.is_a?(Hash)
          details << complex_detail_context(detail_attr)
        elsif public_send(detail_attr).present?
          details << detail_content(detail_attr)
        end
      end.join('. ')
    end

    private

    def default_answer(attribute)
      value = public_send(attribute)
      case value
      when 'unknown', nil
        "<span class='text-error'>Missing</span>"
      when 'no', false
        'No'
      when 'yes', true
        highlight('Yes')
      else
        answer = answer_value(value)
        relevant_answer?(attribute, value) ? highlight(answer) : answer
      end
    end

    def question_condition_unanswered?(attribute)
      answer_state = public_send(question_condition(attribute))
      answer_state.nil? || answer_state == 'unknown'
    end

    def question_condition_answered_yes?(attribute)
      public_send(question_condition(attribute)) == 'yes'
    end

    def checkbox_checked?(attribute)
      public_send(attribute) == true
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

    def highlight(text)
      "<b>#{text}</b>"
    end
  end
end
