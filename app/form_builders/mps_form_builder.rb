class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  class << GovukElementsFormBuilder::FormBuilder
    def localized(scope, attribute, default, object_name)
      @object_name = object_name.gsub(/\[(.*)_attributes\]\[\d+\]/, '.\1')
      key = "#{@object_name}.#{attribute}"
      translate(key, default, scope)
    end
  end

  def error_messages(options = {})
    title = options.fetch(:title, I18n.t('.errors.summary.title'))
    description = options.fetch(:description, '')
    GovukElementsErrorsHelper.error_summary(object, title, description, as: object_name)
  end

  def radio_button_fieldset(attribute, options = {})
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

  def fieldset_legend(attribute, options = {})
    tags = []
    legend_options = options.fetch(:legend_options, {})
    legend = content_tag(:legend) do
      if options.fetch(:legend, true)
        tags << content_tag(
          :span,
          fieldset_text(attribute),
          class: legend_options.fetch(:class, 'form-label-bold')
        )
      end

      tags << error_message_tag_for_attr(attribute) if error_for?(attribute)

      hint = hint_text attribute
      tags << content_tag(:span, hint, class: 'form-hint') if hint

      safe_join tags
    end
    legend.html_safe
  end

  def radio_inputs(attribute, options)
    choices = options[:choices] || %i[yes no]
    choices.map do |choice|
      label(attribute, class: 'block-label', value: choice) do |_tag|
        input = radio_button(attribute, choice)
        input + localized_label("#{attribute}_choices.#{choice}")
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
          radio_button_fieldset attribute,
            options.merge(choices: choices, inline: options.fetch(:inline_choices, true))
        end,
        (content_tag(:div, class: style) { yield } if block_given?)
      ])
    end
  end

  def radio_toggle_with_textarea(attribute, options = {})
    details_attr = options.fetch(:details_attr) { :"#{attribute}_details" }
    radio_toggle(attribute, options.merge(details_attr: details_attr)) do
      text_area_without_label details_attr
    end
  end

  def field_without_label(field_type, attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute.to_sym),
      id: form_group_id(attribute) do
      tags = [content_tag(:span, hint_text(attribute), class: 'form-hint')]
      tags << error_message_tag_for_attr(attribute) if error_for?(attribute)
      tags <<
        field_type.new(
          object.name, attribute, self,
          { value: object.public_send(attribute), class: 'form-control' }.merge(options)
        ).render
      tags.join.html_safe
    end
  end

  def date_picker_text_field(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute.to_sym) + ' date-picker-wrapper',
      id: form_group_id(attribute) do
        set_field_classes! options

        label_tag = label(attribute, class: 'form-label')
        add_hint :label, label_tag, attribute

        date_picker_tag = content_tag :span,
          class: 'date-picker-field input-group date',
          data: { provide: 'datepicker' } do
            date_text_field_tag = custom_text_field(attribute, class: 'no-script form-control date-field')
            calendar_icon_tag = content_tag :span, nil, class: 'no-script calendar-icon input-group-addon'
            (date_text_field_tag + calendar_icon_tag).html_safe
          end
        (label_tag + date_picker_tag).html_safe
      end
  end

  def search_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object.class.name, attribute, self,
      { value: object.public_send(attribute), class: 'form-control' }.merge(options)
    ).render
  end

  def text_area_without_label(attribute)
    field_without_label ActionView::Helpers::Tags::TextArea, attribute
  end

  def text_field_without_label(attribute, options = {})
    field_without_label ActionView::Helpers::Tags::TextField, attribute, options
  end

  def label_with_radio(attribute, text, value)
    label(attribute, value: value, class: 'block-label') do
      safe_join([text, radio_button(attribute, value)])
    end
  end

  def label_with_checkbox(attribute)
    content_tag(:div, class: 'form-group') do
      label(attribute) do
        safe_join([check_box(attribute), localized_label(attribute)])
      end
    end
  end

  def checkbox(attribute)
    style = 'optional-checkbox-section-wrapper'
    style << ' mps-hide' unless object.public_send("#{attribute}?")
    content_tag(:div, class: 'js-checkbox-show-hide form-group') do
      safe_join([
        label(attribute, class: 'block-label') do
          content_tag(:div, class: 'controls-optional-checkbox-section') do
            check_box attribute
          end +
            localized_label(attribute)
        end,
        (content_tag(:div, class: style) { yield } if block_given?)
      ])
    end
  end

  def checkbox_with_textarea(attribute)
    style = 'optional-checkbox-section-wrapper'
    style << ' mps-hide' unless object.public_send("#{attribute}_on?")
    content_tag(:div, class: 'js-checkbox-show-hide form-group') do
      label(attribute, class: 'block-label') do
        content_tag(:div, class: 'controls-optional-checkbox-section') do
          check_box attribute
        end +
          localized_label(attribute)
      end +
        content_tag(:div, class: style) do
          text_area_without_label "#{attribute}_details"
        end
    end
  end

  def radio_concertina_option(attribute, label_text, option)
    safe_join([
      label(attribute, for: "#{option}_toggler", class: 'block-label') do
        safe_join([
          radio_button(attribute, option, id: "#{option}_toggler"),
          label_text
        ])
      end,
      content_tag(:div, class: 'panel panel-border-narrow', data: { toggled_by: "#{option}_toggler" }) do
        yield
      end
    ])
  end

  private

  def custom_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object.class.name, attribute, self,
      { value: object.public_send(attribute), class: 'form-control' }.merge(options)
    ).render
  end

  def style_for_radio_block(attribute, options = {})
    style = 'optional-section-wrapper'
    style << ' mps-hide' unless object.public_send("#{attribute}_on?")
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
end
