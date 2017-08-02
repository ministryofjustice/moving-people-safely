module GovukElementsErrorsHelper
  def self.error_summary(object, heading, description, options = {})
    return unless errors_exist? object
    error_summary_div do
      error_summary_heading(heading) +
        error_summary_description(description) +
        error_summary_list(object, options)
    end
  end

  def self.error_summary_list(object, options = {})
    content_tag(:ul, class: 'error-summary-list') do
      child_to_parents = child_to_parent(object)
      messages = error_summary_messages(object, child_to_parents, options)

      messages << children_with_errors(object).map do |child|
        error_summary_messages(child, child_to_parents, options)
      end

      messages.flatten.join('').html_safe
    end
  end

  def self.error_summary_messages(object, child_to_parents, options = {})
    object.errors.keys.map do |attribute|
      error_summary_message(object, attribute, child_to_parents, options)
    end
  end

  def self.error_summary_message(object, attribute, child_to_parents, options = {})
    messages = object.errors.full_messages_for attribute
    messages.map do |message|
      object_prefixes = options[:as] ? [options[:as]] : object_prefixes(object, child_to_parents)
      link = link_to_error(object_prefixes, attribute)
      content_tag(:li, content_tag(:a, error_message_for_attr(attribute, message, object_prefixes), href: link))
    end
  end

  def self.error_message_for_attr(attribute, message, object_prefixes)
    attribute_parts = attribute.to_s.split(/_([0-9]+)_/)
    if attribute_parts.size > 1
      nested_model = attribute_parts[0]
      object_prefixes << nested_model
      nested_index = attribute_parts[1]
      attribute = attribute_parts[2]
    end

    localised_message = localized_label(object_prefixes, attribute)
    localised_message = nested_error_message(nested_model, nested_index, localised_message) if nested_index
    message.sub! default_label(attribute), localised_message
    message
  end

  def self.nested_error_message(nested_model, nested_index, message)
    "#{default_label(nested_model)} #{nested_index.to_i + 1} #{message}"
  end

  def self.link_to_error(object_prefixes, attribute)
    # Remove possible nested part of attribute.
    # Without this patch the link to a nested field with an error would be:
    # #error_model_attribute.nested_attribute
    # instead of simply:
    # #error_model_attribute
    attribute = attribute.to_s.sub(/\..*/, '')
    ['#error', *object_prefixes, attribute].join('_')
  end

  def self.localized_label(object_prefixes, attribute)
    key = "#{object_prefixes.join('.')}.#{attribute}"
    I18n.t(key,
      default: default_label(attribute),
      scope: 'helpers.label').presence
  end
end
