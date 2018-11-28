class MpsFormBuilder < ActionView::Helpers::FormBuilder
  ActionView::Base.field_error_proc = proc { |html_tag, _instance| html_tag }

  delegate :content_tag, :safe_join, to: :@template

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
      options = args.extract_options!
      options[:class] ||= field_classes(attribute, method_name)

      content_tag :div, class: form_group_classes(attribute), id: form_group_id(attribute) do
        safe_join [
          govuk_label(attribute),
          govuk_hint(attribute),
          govuk_error_message(attribute),
          super(attribute, options)
        ]
      end
    end
  end

  def radios_fieldset(attribute, options = {}, &blk)
    content_tag :div, class: form_group_classes(attribute), id: form_group_id(attribute) do
      content_tag :fieldset, class: 'govuk-fieldset' do
        safe_join [
          govuk_fieldset_legend(attribute),
          govuk_hint(attribute),
          govuk_error_message(attribute),
          govuk_radios(attribute, options, &blk)
        ]
      end
    end
  end

  def radio_toggle_with_textarea(attribute, options = {})
    options[:toggle_choice] ||= 'yes'

    radios_fieldset(attribute, options) do
      text_area :"#{attribute}_details", options
    end
  end

  def radios_item_conditional(attribute, option, &blk)
    safe_join [
      govuk_radios_item(attribute, option),
      govuk_radios_conditional(attribute, option, toggle_choice: option, &blk)
    ]
  end

  def date_picker_text_field(attribute)
    content_tag :div,
      class: form_group_classes(attribute, ['date-picker-wrapper']),
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

  def error_messages
    return unless object.errors.any?

    content_tag(:div, class: 'govuk-error-summary', role: 'alert',
                      aria: { labelledby: 'error-summary-title' },
                      tabindex: '-1', data: { module: 'error-summary' }) do
      error_summary_title + error_summary_body
    end
  end

  def govuk_label(attribute)
    text = localized('helpers.label', attribute)
    return unless text.present?

    classes = ['govuk-label', 'govuk-label--s']
    label(attribute, text, class: classes)
  end

  def govuk_fieldset_legend(attribute)
    text = localized('helpers.fieldset', attribute)
    return unless text.present?

    classes = ['govuk-fieldset__legend', 'govuk-fieldset__legend--s']
    content_tag(:legend, text, class: classes)
  end

  def govuk_hint(attribute)
    text = localized('helpers.hint', attribute)
    return unless text.present?

    content_tag(:span, text, class: 'govuk-hint')
  end

  def govuk_error_message(attribute)
    return unless error_for?(attribute)

    text = error_full_message_for(attribute)
    return unless text.present?

    content_tag(:span, text, class: 'govuk-error-message')
  end

  private

  def custom_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object_name, attribute, self,
      { value: object.public_send(attribute),
        class: 'govuk-input govuk-!-width-one-half' }.merge(options)
    ).render
  end

  def govuk_radios(attribute, options = {}, &blk)
    classes = ['govuk-radios', 'govuk-radios--conditional']
    classes << 'govuk-radios--inline' if options[:inline]

    choices = options[:choices] || %w[yes no]

    radios = choices.map do |choice|
      govuk_radios_item(attribute, choice) +
        govuk_radios_conditional(attribute, choice, options, &blk)
    end

    content_tag(:div, class: classes, data: { module: 'radios' }) do
      safe_join radios
    end
  end

  def govuk_radios_item(attribute, choice)
    content_tag :div, class: 'govuk-radios__item' do
      govuk_radios_input(attribute, choice) +
        govuk_radios_label(attribute, choice)
    end
  end

  def govuk_radios_label(attribute, choice)
    classes = ['govuk-label', 'govuk-radios__label']
    label_for = "#{attribute_prefix}_#{attribute}_#{choice}"

    label(attribute, choice_label_text(attribute, choice), class: classes, for: label_for)
  end

  def govuk_radios_input(attribute, choice)
    classes = ['govuk-radios__input']
    aria_controls = { aria_controls: conditional_id(attribute, choice) }

    radio_button(attribute, choice, class: classes, data: aria_controls)
  end

  def govuk_radios_conditional(attribute, choice, options = {}, &_blk)
    return unless options[:toggle_choice] == choice

    classes = ['govuk-radios__conditional', 'govuk-radios__conditional--hidden']

    content_tag :div, id: conditional_id(attribute, choice), class: classes do
      yield
    end
  end

  def conditional_id(attribute, choice)
    "conditional-#{attribute}-#{choice}"
  end

  def form_group_classes(attribute, optional_classes = [])
    classes = ['govuk-form-group'] + optional_classes
    classes << 'govuk-form-group--error' if error_for?(attribute)
    classes
  end

  def form_group_id(attribute)
    "error_#{attribute_prefix}_#{attribute}" if error_for?(attribute)
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

  def choice_label_text(attribute, choice)
    scope = "helpers.label.#{flattened_object_name}.#{attribute}_choices"
    location_text(translate(choice, scope, choice.to_s.humanize))
  end

  def localized(scope, attribute)
    key = "#{flattened_object_name}.#{attribute}"
    location_text(translate(key, scope))
  end

  def flattened_object_name
    object_name.gsub(/\[(.*)_attributes\]\[\d+\]/, '.\1')
  end

  def default_label(attribute)
    attribute.to_s.split('.').last.humanize.capitalize
  end

  def translate(key, scope, default = '')
    I18n.translate(key, default: default, scope: scope).presence ||
      I18n.translate("#{key}_html", default: default, scope: scope).html_safe.presence
  end

  def location_text(text)
    return unless text
    return text if text.is_a?(String)

    location = object.model&.location&.to_sym
    text[location] || text[:"#{location}_html"]&.html_safe
  end

  def attribute_prefix
    object_name.to_s.tr('[]', '_').squeeze('_').chomp('_')
  end

  def error_for?(attribute)
    object.errors.messages.key?(attribute) && object.errors.messages[attribute].present?
  end

  def error_full_message_for(attribute)
    object.errors.full_messages_for(attribute).first
  end

  def error_summary_title
    content_tag :h2, I18n.t('.errors.summary.title'), id: 'error-summary-title', class: 'govuk-error-summary__title'
  end

  def error_summary_body
    content_tag(:div, class: 'govuk-error-summary__body') do
      content_tag(:ul, class: 'govuk-list govuk-error-summary__list') do
        safe_join errors_with_links
      end
    end
  end

  def errors_with_links
    object.errors.messages.keys.map do |attribute|
      link = ['#error', object_name, attribute.to_s.sub(/\..*/, '')].join('_')
      content_tag(:li, content_tag(:a, error_full_message_for(attribute), href: link))
    end
  end
end
