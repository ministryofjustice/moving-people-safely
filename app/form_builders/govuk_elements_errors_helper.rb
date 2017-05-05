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
      message.sub! default_label(attribute), localized_label(object_prefixes, attribute)
      content_tag(:li, content_tag(:a, message, href: link))
    end
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
end
