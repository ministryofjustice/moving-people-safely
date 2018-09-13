class MpsFormBuilder < ActionView::Helpers::FormBuilder
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    add_error_to_html_tag! html_tag, instance
  end

  delegate :content_tag, :tag, :safe_join, :safe_concat, :capture, to: :@template
  delegate :errors, to: :@object

  # Used to propagate the fieldset outer element attribute to the inner elements
  attr_accessor :current_fieldset_attribute

  # Ensure fields_for yields a GovukElementsFormBuilder.
  def fields_for record_name, record_object = nil, fields_options = {}, &block
    super record_name, record_object, fields_options.merge(builder: self.class), &block
  end

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

        set_label_classes! options
        set_field_classes! options, attribute

        label = label(attribute, options[:label_options])

        add_hint :label, label, attribute

        (label + super(attribute, options.except(:label, :label_options))).html_safe
      end
    end
  end

  def radio_button_fieldset attribute, options={}, &block
    content_tag :div,
                class: form_group_classes(attribute),
                id: form_group_id(attribute) do
      content_tag :fieldset, fieldset_options(attribute, options) do
        safe_join([
                    fieldset_legend(attribute, options),
                    block_given? ? capture(self, &block) : radio_inputs(attribute, options)
                  ], "\n")
      end
    end
  end

  def assessment_text_field(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute),
      id: form_group_id(attribute) do
      content_tag :fieldset, fieldset_options(attribute, options) do
        fieldset_legend(attribute, options) +
          custom_text_field(attribute)
      end
    end
  end

  def location_text_field(attribute, options = {})
    label = label(attribute, location_text(localized_label(attribute)))
    hint = content_tag(:span, location_text(hint_text(attribute)), class: 'govuk-hint')
    text_field(attribute)
    (label + hint + custom_text_field(attribute)).html_safe
  end

  def custom_radio_button_fieldset(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute),
      id: form_group_id(attribute) do
      content_tag :fieldset, fieldset_options(attribute, options) do
        safe_join([
                    fieldset_legend(attribute, options),
                    radio_inputs(attribute, options)
                  ], "\n")
      end
    end
  end

  def custom_check_box_fieldset(attribute)
    content_tag :div, class: 'govuk-form-group' do
      content_tag :div, class: 'multiple-choice' do
        check_box(attribute) +
          label(attribute) { localized_label(attribute) }
      end
    end
  end

  def radio_toggle(attribute, options = {}, &_blk)
    style = style_for_radio_block(attribute, options)
    data = options[:data] || { 'toggle-field' => object.toggle_field }
    choices = options.fetch(:choices) { object.toggle_choices }
    content_tag(:div, class: 'form-group js-show-hide') do
      safe_join([
        content_tag(:div, class: 'controls-optional-section', data: data) do
          custom_radio_button_fieldset attribute,
            options.merge(choices: choices,
                          inline: options.fetch(:inline_choices, true))
        end,
        (content_tag(:div, class: style) { yield } if block_given?)
      ])
    end
  end

  def radio_toggle_with_textarea(attribute, options = {})
    details_attr = options.fetch(:details_attr) { :"#{attribute}_details" }
    radio_toggle(attribute, options.merge(details_attr: details_attr)) do
      text_area_without_label details_attr, options.merge(class: 'govuk-input form-control-3-4')
    end
  end

  def date_picker_text_field(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute.to_sym) + ' date-picker-wrapper',
      id: form_group_id(attribute) do
        set_field_classes! options, attribute

        label_tag = label(attribute, class: 'govuk-label')
        add_hint :label, label_tag, attribute

        date_picker_tag = content_tag :span,
          class: 'date-picker-field input-group date',
          data: { provide: 'datepicker' } do
            date_text_field_tag = custom_text_field(attribute, class: 'no-script govuk-input date-field')
            calendar_icon_tag = content_tag :span, nil, class: 'no-script calendar-icon input-group-addon'
            (date_text_field_tag + calendar_icon_tag).html_safe
          end
        (label_tag + date_picker_tag).html_safe
      end
  end

  def text_area_without_label(attribute, options = {})
    field_without_label ActionView::Helpers::Tags::TextArea, attribute, options
  end

  def text_field_without_label(attribute, options = {})
    field_without_label ActionView::Helpers::Tags::TextField, attribute, options
  end

  def radio_concertina_option(attribute, option)
    safe_join([
      radio_inputs(attribute, choices: [option], id_postfix: '_toggler'),
      content_tag(:div, class: 'panel panel-border-narrow',
                        data: { toggled_by: "#{option}_toggler" }) do
        yield
      end
    ])
  end

  def error_messages(options = {})
    title = options.fetch(:title, I18n.t('.errors.summary.title'))
    description = options.fetch(:description, '')
    ErrorsHelper.error_summary(object, title, description,
      as: object_name)
  end

  private

  def custom_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object_name, attribute, self,
      { value: object.public_send(attribute),
        class: 'govuk-input' }.merge(options)
    ).render
  end

  def fieldset_legend(attribute, options = {})
    tags = []
    legend_options = options.fetch(:legend_options, {})
    legend = content_tag(:legend) do
      if options.fetch(:legend, true)
        tags << content_tag(
          :span,
          location_text(fieldset_text(attribute)),
          class: legend_options.fetch(:class, 'form-label-bold')
        )
      end

      tags << error_message_tag_for_attr(attribute) if error_for?(attribute)

      hint = location_text(hint_text(attribute))
      tags << content_tag(:span, hint, class: 'govuk-hint') if hint

      safe_join tags
    end
    legend.html_safe
  end

  def field_without_label(field_type, attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute.to_sym),
      id: form_group_id(attribute) do
      tags = [content_tag(:span, location_text(hint_text(attribute)), class: 'govuk-hint')]
      tags << error_message_tag_for_attr(attribute) if error_for?(attribute)
      tags <<
        field_type.new(
          object.name, attribute, self,
          { value: object.public_send(attribute),
            class: 'govuk-input govuk-!-width-one-quarter' }.merge(options)
        ).render
      tags.join.html_safe
    end
  end

  def radio_inputs(attribute, options)
    choices = options[:choices] || %i[yes no]
    id_postfix = options[:id_postfix]

    choices.map do |choice|
      value = choice.send(options[:value_method] || :to_s)
      input = radio_button(attribute, choice, radio_options(choice, id_postfix))

      label = label(attribute, label_options(value, choice, id_postfix)) do
        localized_label("#{attribute}_choices.#{choice}")
      end

      content_tag :div, class: 'multiple-choice' do
        input + label
      end
    end
  end

  def self.add_error_to_html_tag! html_tag, instance
    object_name = instance.instance_variable_get(:@object_name)
    object = instance.instance_variable_get(:@object)

    case html_tag
    when /^<label/
      add_error_to_label! html_tag, object_name, object
    when /^<input/
      add_error_to_input! html_tag, 'input'
    when /^<textarea/
      add_error_to_input! html_tag, 'textarea'
    else
      html_tag
    end
  end

  def self.add_error_to_label! html_tag, object_name, object
    field = html_tag[/for="([^"]+)"/, 1]
    object_attribute = object_attribute_for field, object_name
    message = error_full_message_for object_attribute, object_name, object
    if message
      html_tag.sub(
        '</label',
        %Q{<span class="error-message" id="error_message_#{field}">#{message}</span></label}
      ).html_safe # sub() returns a String, not a SafeBuffer
    else
      html_tag
    end
  end

  def self.add_error_to_input! html_tag, element
    field = html_tag[/id="([^"]+)"/, 1]
    html_tag.sub(
      element,
      %Q{#{element} aria-describedby="error_message_#{field}"}
    ).html_safe # sub() returns a String, not a SafeBuffer
  end

  def self.object_attribute_for field, object_name
    field.to_s.
      sub("#{attribute_prefix(object_name)}_", '').
      to_sym
  end

  def form_group_classes attributes
    attributes = [attributes] if !attributes.respond_to? :count
    classes = 'govuk-form-group'
    classes += ' form-group-error' if attributes.find { |a| error_for? a }
    classes
  end

  def error_for? attribute
    object.respond_to?(:errors) &&
    errors.messages.key?(attribute) &&
    !errors.messages[attribute].empty?
  end

  def location_text(text)
    return unless text
    return text if text.is_a?(String)
    location = object.model&.location&.to_sym
    text[location] || text[:"#{location}_html"].html_safe
  end

  def radio_options(choice, id_postfix)
    id_postfix ? { id: choice.to_s + id_postfix.to_s } : {}
  end

  def label_options(value, choice, id_postfix)
    { value: value }.tap do |options|
      options.merge!(for: choice.to_s + id_postfix.to_s) if id_postfix
    end
  end

  def style_for_radio_block(attribute, options = {})
    style = 'optional-section-wrapper mps-hide'
    style << error_style_for_attr(options[:details_attr])
  end

  def error_style_for_attr(attribute)
    return ' toggle_with_error' if attribute && error_for?(attribute)
    ' panel panel-border-narrow'
  end

  def error_message_tag_for_attr(attribute)
    content_tag(
      :span,
      error_full_message_for(attribute),
      class: 'error-message'
    )
  end

  def form_group_id attribute
    "error_#{attribute_prefix}_#{attribute}" if error_for? attribute
  end

  def set_label_classes! options
    options ||= {}
    options[:label_options] ||= {}
    options[:label_options].merge!(
      merge_attributes(options[:label_options], default: {class: 'govuk-label'})
    )
  end

  def merge_attributes attributes, default:
    hash = attributes || {}
    hash.merge(default) { |_key, oldval, newval| Array(newval) + Array(oldval) }
  end

  def fieldset_options attribute, options
    self.current_fieldset_attribute = attribute

    fieldset_options = {}
    fieldset_options[:class] = 'inline' if options[:inline] == true
    fieldset_options
  end

  def set_field_classes! options, attribute
    default_classes = ['govuk-input govuk-!-width-one-quarter']
    default_classes << 'form-control-error' if error_for?(attribute)

    options ||= {}
    options.merge!(
      merge_attributes(options, default: {class: default_classes})
    )
  end

  def add_hint tag, element, name
    if hint = hint_text(name)
      hint_span = content_tag(:span, hint, class: 'govuk-hint')
      element.sub!("</#{tag}>", "#{hint_span}</#{tag}>".html_safe)
    end
  end

  def fieldset_text attribute
    localized 'helpers.fieldset', attribute, default_label(attribute)
  end

  def hint_text attribute
    localized 'helpers.hint', attribute, ''
  end

  def self.localized(scope, attribute, default, object_name)
    @object_name = object_name.gsub(/\[(.*)_attributes\]\[\d+\]/, '.\1')
    key = "#{@object_name}.#{attribute}"
    translate(key, default, scope)
  end

  def localized scope, attribute, default
    self.class.localized scope, attribute, default, @object_name
  end

  def self.localized_label attribute, object_name
    localized 'helpers.label', attribute, default_label(attribute), object_name
  end

  def localized_label attribute
    self.class.localized_label attribute, @object_name
  end

  def self.default_label attribute
    attribute.to_s.split('.').last.humanize.capitalize
  end

  def default_label attribute
    self.class.default_label attribute
  end

  def self.attribute_prefix object_name
    object_name.to_s.tr('[]','_').squeeze('_').chomp('_')
  end

  def attribute_prefix
    self.class.attribute_prefix(@object_name)
  end

  def self.error_full_message_for attribute, object_name, object
    message = object.errors.full_messages_for(attribute).first
    message&.sub default_label(attribute), localized_label(attribute, object_name)
  end

  def error_full_message_for attribute
    self.class.error_full_message_for attribute, @object_name, @object
  end

  def self.translate key, default, scope
    # Passes blank String as default because nil is interpreted as no default
    I18n.translate(key, default: '', scope: scope).presence ||
    I18n.translate("#{key}_html", default: default, scope: scope).html_safe.presence
  end
end
