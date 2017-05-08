module ApplicationHelper
  def flash_message_for(messages)
    return messages unless messages.is_a?(Array)
    content_tag(:ul) do
      safe_join(messages.map { |msg| content_tag(:li, msg) })
    end
  end

  def link_to_print_in_new_window(escort, text: 'Print', styles: nil)
    link_to(text, escort_print_path(escort), target: :_blank, class: styles)
  end

  def select_values_for(field)
    I18n.t("helpers.label.#{field}_choices").invert
  end

  def fieldset_title(section, field)
    scope = %i[helpers fieldset]
    default_title = I18n.t('default_title', scope: scope)
    I18n.t("#{section}.#{field}", scope: scope, default: default_title)
  end
end
