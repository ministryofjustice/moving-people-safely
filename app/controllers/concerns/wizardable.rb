# frozen_string_literal: true

module Wizardable
  extend ActiveSupport::Concern

  included do
    def setup_wizard
      check_steps!

      @step = setup_step_from(params[:step])
      set_previous_next(@step)
    end

    def wizard_path(goto_step = nil, options = {})
      options = options.merge(step: goto_step || params[:step])
      super(goto_step, options)
    end

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
