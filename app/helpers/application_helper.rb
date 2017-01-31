module ApplicationHelper
  def flash_message_for(messages)
    return messages unless messages.is_a?(Array)
    content_tag(:ul) do
      safe_join(messages.map { |msg| content_tag(:li, msg) })
    end
  end
end
