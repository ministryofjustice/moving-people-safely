module Summary
  class RiskPresenter < SummaryPresenter
    attr_reader :section_name
    delegate :name, :questions, to: :section
    delegate :question_is_conditional?, :question_condition, to: :section

    def self.for(section, risk)
      klass = case section.to_s
              when 'sex_offences'
                Summary::Risks::SexOffencesSectionPresenter
              else
                self
              end
      klass.new(risk, section: section)
    end

    def initialize(object, options = {})
      super(object)
      @section_name = options.fetch(:section)
    end

    def answer_for(attribute)
      return super(attribute) unless question_is_conditional?(attribute)
      if question_condition_unanswered?(attribute)
        "<span class='text-error'>Missing</span>"
      elsif question_condition_answered_yes?(attribute) && checkbox_checked?(attribute)
        '<b>Yes</b>'
      else
        'No'
      end
    end

    private

    def section
      @section ||= RiskAssessment.section_for(section_name)
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
  end
end
