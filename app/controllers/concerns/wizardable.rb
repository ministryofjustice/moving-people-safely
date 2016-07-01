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

    def redirect_after_update
      if params.key?('save_and_view_profile') || !can_skip?
        redirect_to profile_path(escort)
      else
        redirect_to next_wizard_path
      end
    end
  end
end
