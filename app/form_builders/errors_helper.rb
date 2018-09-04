module ErrorsHelper
  class << self
    include ActionView::Context
    include ActionView::Helpers::TagHelper
  end

  def self.error_summary(object, heading, description, options = {})
    return unless errors_exist? object
    error_summary_div do
      error_summary_heading(heading) +
        error_summary_description(description) +
        error_summary_list(object, options)
    end
  end

  def self.attributes object, parent_object=nil
    return [] if object == parent_object
    parent_object ||= object

    child_objects = attribute_objects object
    nested_child_objects = child_objects.map { |o| attributes(o, parent_object) }
    (child_objects + nested_child_objects).flatten - [object]
  end

  def self.attribute_objects object
    object.
      instance_variables.
      map { |var| instance_variable(object, var) }.
      compact
  end

  def self.error_summary_heading text
    content_tag :h1,
      text,
      id: 'error-summary-heading',
      class: 'heading-medium error-summary-heading'
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

  def self.instance_variable object, var
    field = var.to_s.sub('@','').to_sym
    if object.respond_to?(field)
      child = object.send(field)
      if respond_to_errors?(child) || child.is_a?(Array)
        child
      else
        nil
      end
    end
  end

  def self.error_summary_div &block
    content_tag(:div,
        class: 'error-summary',
        role: 'group',
        aria: {
          labelledby: 'error-summary-heading'
        },
        tabindex: '-1') do
      yield block
    end
  end

  def self.errors_exist? object
    errors_present?(object) || child_errors_present?(object)
  end

  def self.errors_present? object
    respond_to_errors?(object) && object.errors.present?
  end

  def self.respond_to_errors? object
    object && object.respond_to?(:errors)
  end

  def self.child_errors_present? object
    attributes(object).any? { |child| errors_exist?(child) }
  end

  def self.error_summary_description text
    content_tag :p, text
  end

  def self.child_to_parent object, child_to_parents={}, parent_object=nil
    return child_to_parents if object == parent_object
    parent_object ||= object

    attribute_objects(object).each do |child|
      if child.is_a?(Array)
        array_to_parent(child, object, child_to_parents, parent_object)
      else
        child_to_parents[child] = object
        child_to_parent child, child_to_parents, parent_object
      end
    end

    child_to_parents
  end

  def self.default_label attribute
    attribute.to_s.humanize.capitalize
  end

  def self.children_with_errors object
    attributes(object).select { |child| errors_present?(child) }
  end
end
