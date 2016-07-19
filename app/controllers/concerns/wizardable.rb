module Wizardable
  extend ActiveSupport::Concern

  included do
    def current_question
      current_step_index + 1
    end
    helper_method :current_question

    def total_questions
      wizard_steps.size
    end
    helper_method :total_questions

    def can_go_back?
      previous_step != step
    end
    helper_method :can_go_back?

    def can_skip?
      next_step != 'wicked_finish'
    end
    helper_method :can_skip?
  end
end
