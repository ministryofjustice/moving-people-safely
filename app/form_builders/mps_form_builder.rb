class MpsFormBuilder < ActionView::Helpers::FormBuilder
  ActionView::Base.field_error_proc = proc do |html_tag, instance|
    add_error_to_html_tag! html_tag, instance
  end

  delegate :content_tag, :tag, :safe_join, :safe_concat, :capture, to: :@template
  delegate :errors, to: :@object

  # Used to propagate the fieldset outer element attribute to the inner elements
  attr_accessor :current_fieldset_attribute

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

        add_label_classes! options
        add_field_classes! options, attribute, method_name

        label = label(attribute, options[:label_options])

        hint = add_hint :label, label, attribute

        label + hint + super(attribute, options.except(:label, :label_options))
      end
    end
  end

  def assessment_text_field(attribute, options = {})
    content_tag :div, class: form_group_classes(attribute), id: form_group_id(attribute) do
      content_tag :fieldset, fieldset_options(attribute) do
        fieldset_legend(attribute, options) +
          custom_text_field(attribute)
      end
    end
  end

  def location_text_field(attribute, _options = {})
    label = label(attribute, location_text(localized_label(attribute)), class: 'govuk-label')
    hint = ''
    unless location_text(hint_text(attribute)).empty?
      hint = content_tag(:span, location_text(hint_text(attribute)), class: 'govuk-hint')
    end
    text_field(attribute)
    label + hint + custom_text_field(attribute)
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

  def custom_check_box_fieldset(attribute)
    content_tag :div, class: 'govuk-form-group' do
      content_tag :div, class: 'multiple-choice' do
        check_box(attribute) +
          label(attribute) { localized_label(attribute) }
      end
    end
  end

  def radio_toggle(attribute, options = {}, &blk)
    choices = options.fetch(:choices) { object.toggle_choices }
    toggle_options = options[:toggle_options] || []
    fieldset_options = options.merge(
      choices: choices,
      inline: options.fetch(:inline_choices, false),
      toggle_options: toggle_options
    )

    custom_radio_button_fieldset(attribute, fieldset_options, &blk)
  end

  def radio_toggle_with_textarea(attribute, options = {})
    details_attr = options.fetch(:details_attr) { :"#{attribute}_details" }
    radio_toggle(attribute, options.merge(details_attr: details_attr)) do
      text_area_without_label details_attr, options.merge(class: 'govuk-textarea govuk-!-width-one-half')
    end
  end

  def date_picker_text_field(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute) + ' date-picker-wrapper',
      id: form_group_id(attribute) do
        add_field_classes! options, attribute

        label_tag = label(attribute, class: 'govuk-label')
        hint = add_hint :label, label_tag, attribute

        date_picker_tag = content_tag :span,
          class: 'date-picker-field input-group date',
          data: { provide: 'datepicker' } do
            date_text_field_tag = custom_text_field(attribute, class: 'no-script govuk-input date-field')
            calendar_icon_tag = content_tag :span, nil, class: 'no-script calendar-icon input-group-addon'
            (date_text_field_tag + calendar_icon_tag).html_safe
          end
        label_tag + hint + date_picker_tag
      end
  end

  def text_area_without_label(attribute, options = {})
    field_without_label ActionView::Helpers::Tags::TextArea, attribute, options
  end

  def text_field_without_label(attribute, options = {})
    field_without_label ActionView::Helpers::Tags::TextField, attribute, options
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
    title = options.fetch(:title, I18n.t('.errors.summary.title'))
    description = options.fetch(:description, '')
    ErrorsHelper.error_summary(object, title, description, as: object_name)
  end

  private

  def custom_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object_name, attribute, self,
      { value: object.public_send(attribute),
        class: 'govuk-input govuk-!-width-one-half' }.merge(options)
    ).render
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

      tags << error_message_tag_for_attr(attribute) if error_for?(attribute)

      hint = location_text(hint_text(attribute))
      tags << content_tag(:span, hint, class: 'govuk-hint') if hint

      safe_join tags
    end
    legend.html_safe
  end

  def field_without_label(field_type, attribute, options = {})
    default_input_classes = if field_type.to_s.include? 'TextArea'
                              'govuk-textarea govuk-!-width-one-half'
                            else
                              'govuk-input govuk-!-width-one-quarter'
                            end
    content_tag :div, class: form_group_classes(attribute.to_sym), id: form_group_id(attribute) do
      label_tag = content_tag(:label, location_text(hint_text(attribute)),
        for: "#{object.name}_#{attribute}",
        class: 'govuk-hint govuk-label')
      tags = [label_tag]
      tags << error_message_tag_for_attr(attribute) if error_for?(attribute)
      tags <<
        field_type.new(
          object.name, attribute, self,
          { value: object.public_send(attribute),
            class: default_input_classes }.merge(options)
        ).render
      tags.join.html_safe
    end
  end

  def radio_inputs(attribute, options, &_blk)
    choices = options[:choices] || %i[yes no]
    id_postfix = options[:id_postfix]

    choices.map do |choice|
      value = choice.send(options[:value_method] || :to_s)
      input = radio_button(attribute, choice, radio_options(attribute, choice, id_postfix))

      label = label(attribute, label_options(value, choice, id_postfix)) do
        localized_label("#{attribute}_choices.#{choice}")
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

      radio_html + conditional_html.html_safe
    end
  end

  def form_group_classes(attributes)
    attributes = [attributes] unless attributes.respond_to? :count
    classes = 'govuk-form-group'
    classes += ' govuk-form-group--error' if attributes.find { |a| error_for? a }
    classes
  end

  def error_for?(attribute)
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

  def error_message_tag_for_attr(attribute)
    content_tag(:span, error_full_message_for(attribute), class: 'govuk-error-message')
  end

  def form_group_id(attribute)
    "error_#{attribute_prefix}_#{attribute}" if error_for? attribute
  end

  def add_label_classes!(options)
    options[:label_options] ||= {}
    options[:label_options].merge!(class: 'govuk-label')
  end

  def fieldset_options(attribute)
    self.current_fieldset_attribute = attribute

    fieldset_options = {}
    fieldset_options[:class] = 'govuk-fieldset'
    fieldset_options
  end

  def add_field_classes!(options, attribute, method_name = 'text_field')
    default_classes = if method_name.to_s.strip == 'text_area'
                        ['govuk-textarea', options[:width_option] || 'govuk-!-width-one-half']
                      else
                        ['govuk-input', options[:width_option] || 'govuk-!-width-one-quarter']
                      end
    default_classes << 'form-control-error' if error_for?(attribute)

    options.merge!(class: default_classes)
  end

  def add_hint(_tag, _element, name)
    return unless hint_text(name)

    content_tag(:span, hint_text(name), class: 'govuk-hint')
  end

  def fieldset_text(attribute)
    localized 'helpers.fieldset', attribute, default_label(attribute)
  end

  def hint_text(attribute)
    localized 'helpers.hint', attribute, ''
  end

  def localized(scope, attribute, default)
    self.class.localized scope, attribute, default, @object_name
  end

  def localized_label(attribute)
    self.class.localized_label attribute, @object_name
  end

  def default_label(attribute)
    self.class.default_label attribute
  end

  def attribute_prefix
    self.class.attribute_prefix(@object_name)
  end

  def error_full_message_for(attribute)
    self.class.error_full_message_for attribute, @object_name, @object
  end

  class << self
    def add_error_to_html_tag!(html_tag, instance)
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

    def add_error_to_label!(html_tag, object_name, object)
      field = html_tag[/for="([^"]+)"/, 1]
      object_attribute = object_attribute_for field, object_name
      message = error_full_message_for object_attribute, object_name, object
      if message
        html_tag.sub(
          '</label',
          %(<span class="govuk-error-message" id="error_message_#{field}">#{message}</span></label)
        ).html_safe # sub() returns a String, not a SafeBuffer
      else
        html_tag
      end
    end

    def add_error_to_input!(html_tag, element)
      field = html_tag[/id="([^"]+)"/, 1]
      html_tag.sub(
        element,
        %(#{element} aria-describedby="error_message_#{field}")
      ).html_safe # sub() returns a String, not a SafeBuffer
    end

    def object_attribute_for(field, object_name)
      field.to_s.sub("#{attribute_prefix(object_name)}_", '').to_sym
    end

    def localized(scope, attribute, default, object_name)
      @object_name = object_name.gsub(/\[(.*)_attributes\]\[\d+\]/, '.\1')
      key = "#{@object_name}.#{attribute}"
      translate(key, default, scope)
    end

    def localized_label(attribute, object_name)
      localized 'helpers.label', attribute, default_label(attribute), object_name
    end

    def default_label(attribute)
      attribute.to_s.split('.').last.humanize.capitalize
    end

    def attribute_prefix(object_name)
      object_name.to_s.tr('[]', '_').squeeze('_').chomp('_')
    end

    def error_full_message_for(attribute, object_name, object)
      message = object.errors.full_messages_for(attribute).first
      message&.sub default_label(attribute), localized_label(attribute, object_name)
    end

    def translate(key, default, scope)
      # Passes blank String as default because nil is interpreted as no default
      I18n.translate(key, default: '', scope: scope).presence ||
        I18n.translate("#{key}_html", default: default, scope: scope).html_safe.presence
    end
  end
end
