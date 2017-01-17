module Summary
  class AssessmentSectionPresenter < SummaryPresenter
    attr_reader :section_name
    delegate :name, :questions, to: :section
    delegate :question_is_conditional?, :question_condition, to: :section
    delegate :question_has_details?, :question_details, to: :section
    delegate :subsections, :has_subsections?, :questions_for_subsection, to: :section

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
        details << detail_content(detail_attr) if public_send(detail_attr).present?
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
      when true
        '<b>Yes</b>'
      when 'standard'
        'Standard'
      else
        "<b>#{answer_value(value)}</b>"
      end
    end

    def question_condition_unanswered?(attribute)
      public_send(question_condition(attribute)) == 'unknown'
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

    def detail_label(attribute)
      I18n.t!(attribute, scope: [:summary, :section, :questions, section_name])
    rescue
      nil
    end

    def answer_value(value)
      default_value = value.respond_to?(:humanize) ? value.humanize : value
      I18n.t(value, scope: [:summary, :section, :answers, section_name], default: default_value)
    end
  end
end
