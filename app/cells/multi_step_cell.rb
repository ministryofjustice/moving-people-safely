require 'cell/translation'

class MultiStepCell < Cell::ViewModel
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::FormOptionsHelper
  include Cell::Translation

  attr_accessor :form_title,
    :prev_path,
    :next_path,
    :current_question,
    :total_questions,
    :form_path,
    :form_content

  property :form

  alias_method :form, :model

  def title
    t(".#{form_title}")
  end

  def back_link
    link_to '< Back', prev_path if prev_path
  end

  def next_link
    link_to 'Skip >', next_path if next_path
  end

  def current_question_text
    "Question #{current_question} of #{total_questions}"
  end

  def page_class
    form.model.class.name
  end

  def select_values_for(key)
    t(".#{key}").invert
  end
end
