class MpsFormBuilder < ActionView::Helpers::FormBuilder
  ActionView::Base.field_error_proc = proc { |html_tag, _instance| html_tag }

  delegate :content_tag, :tag, :safe_join, :safe_concat, :capture, to: :@template
  delegate :errors, to: :@object

  %i[
    email_field
    password_field
    number_field
    phone_field
    range_field
    search_field
    telephone_field
    text_area
    text_field
    url_field
  ].each do |method_name|
    define_method(method_name) do |attribute, *args|
      content_tag :div, class: form_group_classes(attribute), id: form_group_id(attribute) do
        options = args.extract_options!
        field_classes = field_classes(attribute, method_name)

        label = govuk_label(attribute)
        hint = govuk_hint(attribute)
        error = govuk_error_message(attribute) if error_for?(attribute)
        field = super(attribute, options.merge(class: field_classes))

        safe_join [label, hint, error, field]
      end
    end
  end

  def govuk_label(attribute)
    text = label_text(attribute)
    return unless text.present?

    label(attribute, text, class: 'govuk-label')
  end

  def govuk_hint(attribute)
    text = hint_text(attribute)
    return unless text.present?

    content_tag(:span, text, class: 'govuk-hint')
  end

  def govuk_error_message(attribute)
    text = error_full_message_for(attribute)
    return unless text.present?

    content_tag(:span, text, class: 'govuk-error-message')
  end

  def custom_radio_button_fieldset(attribute, options = {}, &blk)
    wrapper_class = 'govuk-radios'
    wrapper_class += ' govuk-radios--inline' if options[:inline]

    content_tag :div, class: form_group_classes(attribute), id: form_group_id(attribute) do
      content_tag :fieldset, fieldset_options(attribute) do
        fieldset_legend(attribute, options) +
          content_tag(:div, class: wrapper_class, data: { module: 'radios' }) do
            radio_inputs(attribute, options, &blk).join.html_safe
          end
      end
    end
  end

  def radio_toggle(attribute, options = {}, &blk)
    options[:toggle_options] ||= ['yes']
    options[:choices] ||= object.toggle_choices

    custom_radio_button_fieldset(attribute, options, &blk)
  end

  def radio_toggle_with_textarea(attribute, options = {})
    details_attr = options.fetch(:details_attr) { :"#{attribute}_details" }
    radio_toggle(attribute, options) do
      text_area details_attr, options
    end
  end

  def date_picker_text_field(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute) + ' date-picker-wrapper',
      id: form_group_id(attribute) do
        date_picker_tag = content_tag :span,
          class: 'date-picker-field input-group date',
          data: { provide: 'datepicker' } do
            date_text_field_tag = custom_text_field(attribute, class: 'no-script govuk-input date-field')
            calendar_icon_tag = content_tag :span, nil, class: 'no-script calendar-icon input-group-addon'
            (date_text_field_tag + calendar_icon_tag).html_safe
          end
        govuk_label(attribute) + govuk_hint(attribute) + date_picker_tag
      end
  end

  def radio_concertina_option(attribute, option)
    radio_classes = 'govuk-radios__conditional govuk-radios__conditional--hidden'
    radio_id = "conditional-#{attribute}-#{option}-radio"
    safe_join([
      radio_inputs(attribute, choices: [option], id_postfix: '-radio'),
      content_tag(:div, id: radio_id, class: radio_classes) { yield }
    ])
  end

  def error_messages(options = {})
    return unless errors_exist? object

    error_summary_div do
      error_summary_heading + error_summary_list
    end
  end

  def fieldset_legend(attribute, options = {})
    tags = []
    legend_options = options.fetch(:legend_options, {})
    legend = content_tag(:legend, class: 'govuk-fieldset__legend') do
      if options.fetch(:legend, true)
        tags << content_tag(
          :span,
          location_text(fieldset_text(attribute)),
          class: legend_options.fetch(:class, 'form-label-bold')
        )
      end

      tags << govuk_error_message(attribute) if error_for?(attribute)

      hint = location_text(hint_text(attribute))
      tags << content_tag(:span, hint, class: 'govuk-hint') if hint

      safe_join tags
    end
    legend.html_safe
  end

  private

  def custom_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object_name, attribute, self,
      { value: object.public_send(attribute),
        class: 'govuk-input govuk-!-width-one-half' }.merge(options)
    ).render
  end

  def radio_inputs(attribute, options, &_blk)
    choices = options[:choices] || %i[yes no]
    id_postfix = options[:id_postfix]

    choices.map do |choice|
      value = choice.send(options[:value_method] || :to_s)
      input = radio_button(attribute, choice, radio_options(attribute, choice, id_postfix))

      label = label(attribute, label_options(value, choice, id_postfix)) do
        scope = "helpers.label.#{object_name}.#{attribute}_choices"
        translate(choice, scope, value.humanize)
      end
      radio_html = content_tag :div, class: 'govuk-radios__item' do
        input + label
      end

      conditional_html = ''
      if options[:toggle_options]&.include?(choice)
        html_id = "conditional-#{attribute}-#{choice}"
        html_class = 'govuk-radios__conditional govuk-radios__conditional--hidden'
        conditional_html = content_tag :div, id: html_id, class: html_class do
          yield if block_given?
        end
      end

      safe_join([radio_html, conditional_html])
    end
  end

  def form_group_classes(attribute)
    classes = 'govuk-form-group'
    classes += ' govuk-form-group--error' if error_for?(attribute)
    classes
  end

  def form_group_id(attribute)
    "error_#{attribute_prefix}_#{attribute}" if error_for?(attribute)
  end

  def error_for?(attribute)
    errors.messages.key?(attribute) && errors.messages[attribute].present?
  end

  def location_text(text)
    return unless text
    return text if text.is_a?(String)

    location = object.model&.location&.to_sym
    text[location] || text[:"#{location}_html"].html_safe
  end

  def radio_options(attribute, choice, id_postfix)
    conditional = 'conditional-' + attribute.to_s + '-' + choice.to_s
    {
      class: 'govuk-radios__input',
      data: { aria_controls: conditional }
    }.tap do |options|
      options.merge!(id: choice.to_s + id_postfix.to_s, data: { aria_controls: conditional + id_postfix.to_s }) if id_postfix
    end
  end

  def label_options(value, choice, id_postfix)
    { value: value, class: 'govuk-label govuk-radios__label' }.tap do |options|
      options.merge!(for: choice.to_s + id_postfix.to_s) if id_postfix
    end
  end

  def style_for_radio_block(_attribute, options = {})
    style = 'govuk-radios__conditional govuk-radios__conditional--hidden'
    style << error_style_for_attr(options[:details_attr])
  end

  def error_style_for_attr(attribute)
    attribute && error_for?(attribute) ? ' toggle_with_error' : ''
  end

  def fieldset_options(_attribute)
    fieldset_options = {}
    fieldset_options[:class] = 'govuk-fieldset'
    fieldset_options
  end

  def field_classes(attribute, method_name = :text_area)
    govuk_input_classes = ['govuk-input', 'govuk-!-width-one-quarter']
    govuk_textarea_classes = ['govuk-textarea', 'govuk-!-width-one-half']

    classes = if method_name == :text_area
                govuk_textarea_classes
              else
                govuk_input_classes
              end

    classes << "#{classes.first}--error" if error_for?(attribute)
    classes
  end

  def label_text(attribute)
    localized('helpers.label', attribute)
  end

  def hint_text(attribute)
    localized('helpers.hint', attribute)
  end

  def fieldset_text(attribute)
    localized('helpers.fieldset', attribute)
  end

  def localized(scope, attribute)
    name = object_name.gsub(/\[(.*)_attributes\]\[\d+\]/, '.\1')
    key = "#{name}.#{attribute}"
    location_text(translate(key, scope))
  end

  def default_label(attribute)
    attribute.to_s.split('.').last.humanize.capitalize
  end

  def attribute_prefix
    object_name.to_s.tr('[]', '_').squeeze('_').chomp('_')
  end

  def error_full_message_for(attribute)
    message = object.errors.full_messages_for(attribute).first
  end

  def translate(key, scope, default = '')
    # Passes blank String as default because nil is interpreted as no default
    I18n.translate(key, default: default, scope: scope).presence ||
      I18n.translate("#{key}_html", default: default, scope: scope).html_safe.presence
  end

  def attributes(object, parent_object = nil)
    return [] if object == parent_object

    parent_object ||= object

    child_objects = attribute_objects object
    nested_child_objects = child_objects.map { |o| attributes(o, parent_object) }
    (child_objects + nested_child_objects).flatten - [object]
  end

  def attribute_objects(object)
    object.instance_variables.map { |var| instance_variable(object, var) }.compact
  end

  def error_summary_heading
    content_tag :h2, I18n.t('.errors.summary.title'), id: 'error-summary-title', class: 'govuk-error-summary__title'
  end

  def error_summary_list(options = {})
    content_tag(:div, class: 'govuk-error-summary__body') do
      content_tag(:ul, class: 'govuk-list govuk-error-summary__list') do
        child_to_parents = child_to_parent(object)
        messages = error_summary_messages(object, child_to_parents, options)

        messages << children_with_errors(object).map do |child|
          error_summary_messages(child, child_to_parents, options)
        end

        messages.flatten.join('').html_safe
      end
    end
  end

  def error_summary_messages(object, child_to_parents, options = {})
    object.errors.keys.map do |attribute|
      error_summary_message(object, attribute, child_to_parents, options)
    end
  end

  def error_summary_message(object, attribute, child_to_parents, options = {})
    messages = object.errors.full_messages_for attribute
    messages.map do |message|
      link = link_to_error(object_name, attribute)
      content_tag(:li, content_tag(:a, error_message_for_attr(attribute, message, object_name), href: link))
    end
  end

  def error_message_for_attr(attribute, message, object_prefixes)
    attribute_parts = attribute.to_s.split(/_([0-9]+)_/)
    if attribute_parts.size > 1
      nested_model = attribute_parts[0]
      object_prefixes << nested_model
      nested_index = attribute_parts[1]
      attribute = attribute_parts[2]
    end

    localised_message = location_text(label_text(attribute)).presence || object.class.human_attribute_name(attribute)
    localised_message = nested_error_message(nested_model, nested_index, localised_message) if nested_index
    message.sub! default_label(attribute), localised_message
    message
  end

  def nested_error_message(nested_model, nested_index, message)
    "#{default_label(nested_model)} #{nested_index.to_i + 1} #{message}"
  end

  def link_to_error(object_prefixes, attribute)
    attribute = attribute.to_s.sub(/\..*/, '')
    ['#error', *object_prefixes, attribute].join('_')
  end

  def instance_variable(object, var)
    field = var.to_s.sub('@', '').to_sym
    if object.respond_to?(field)
      child = object.send(field)
      child if respond_to_errors?(child) || child.is_a?(Array)
    end
  end

  def error_summary_div(&block)
    content_tag(:div,
      class: 'govuk-error-summary',
      role: 'alert',
      aria: {
        labelledby: 'error-summary-title'
      },
      tabindex: '-1',
      data: {
        module: 'error-summary'
      }) do
      yield block
    end
  end

  def errors_exist?(object)
    errors_present?(object) || child_errors_present?(object)
  end

  def errors_present?(object)
    respond_to_errors?(object) && object.errors.present?
  end

  def respond_to_errors?(object)
    object&.respond_to?(:errors)
  end

  def child_errors_present?(object)
    attributes(object).any? { |child| errors_exist?(child) }
  end

  def error_summary_description(text)
    content_tag :p, text
  end

  def child_to_parent(object, child_to_parents = {}, parent_object = nil)
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

  def children_with_errors(object)
    attributes(object).select { |child| errors_present?(child) }
  end
end
