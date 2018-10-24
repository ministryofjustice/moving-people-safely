module ApplicationHelper
  def current_phase
    Rails.application.config.phase
  end

  def feedback_url
    Rails.application.config.feedback_url
  end

  def flash_message_for(messages)
    return messages unless messages.is_a?(Array)
    content_tag(:ul) do
      safe_join(messages.map { |msg| content_tag(:li, msg) })
    end
  end

  def link_to_print_in_new_window(escort, text: 'Print', styles: nil)
    link_to(text, escort_print_path(escort), target: :_blank, class: styles)
  end

  def summary_answer(value)
    case value
    when nil
      "<span class='govuk-error-message'>Missing</span>"
    when 'no', 'none', 'standard'
      value.capitalize
    else
      "<b>#{value.humanize.capitalize}</b>"
    end
  end

  def highlighted_content(content)
    content_tag(:div, content, class: 'strong-text')
  end

  def content_or_none(content)
    content.present? ? content : 'None'
  end

  def answer_details(*answers)
    answers.compact.map(&:capitalize).join(' | ')
  end

  def location_text(text, location)
    return unless text
    return text if text.is_a?(String)
    text[location.to_sym] || text[:"#{location}_html"].html_safe
  end
end
