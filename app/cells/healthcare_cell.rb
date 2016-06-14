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
    total_steps = Forms::Healthcare::StepManager.total_steps
    current_step = model.node_position
    "Question #{current_step} of #{total_steps}"
  end

  def template_name
    model.name
  end

  def form_path
    model.path
  end
end
