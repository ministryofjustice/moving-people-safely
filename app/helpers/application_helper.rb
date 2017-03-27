module ApplicationHelper
  def flash_message_for(messages)
    return messages unless messages.is_a?(Array)
    content_tag(:ul) do
      safe_join(messages.map { |msg| content_tag(:li, msg) })
    end
  end

  def link_to_print_in_new_window(move, text: 'Print', styles: nil)
    link_to(text, move_print_path(move), target: :_blank, class: styles)
  end
end
