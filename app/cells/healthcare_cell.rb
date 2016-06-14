require 'cell/translation'

class HealthcareCell < Cell::ViewModel
  include ActionView::Helpers::TranslationHelper
  include Cell::Translation

  property :form

  def title
    t(".#{model.name}")
  end

  def back_link
    link_to '< Back', model.prev_path
  end

  def next_link
    link_to 'Skip >', model.next_path
  end

  def current_question_text
    current_question = model.node_position
    total_questions = Forms::Healthcare::StepManager.total_steps
    "Question #{current_question} of #{total_questions}"
  end

  def template_name
    model.name
  end

  def form_path
    model.path
  end
end
