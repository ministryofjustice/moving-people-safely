require 'cell/translation'

class RisksCell < Cell::ViewModel
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::FormOptionsHelper
  include Cell::Translation

  property :form

  alias_method :step, :model

  def title
    t(".#{model.name}")
  end

  def back_link
    link_to '< Back', step.prev_path if step.has_prev?
  end

  def next_link
    link_to 'Skip >', step.next_path if step.has_next?
  end

  def current_question_text
    current_question = step.node_position
    total_questions = Forms::Risks::StepManager.total_steps
    "Question #{current_question} of #{total_questions}"
  end

  def template_name
    step.name
  end

  def form_path
    step.path
  end

  def select_values_for(key)
    t(".#{key}").invert
  end
end
