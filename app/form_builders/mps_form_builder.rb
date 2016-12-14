class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  def error_style_for_attr(attribute)
    return ' toggle_with_error' if attribute && error_for?(attribute)
    ' panel panel-border-narrow'
  end

  def radio_toggle(attribute, options = {}, &_blk)
    style = 'optional-section-wrapper'
    style << ' mps-hide' unless object.public_send("#{attribute}_on?")
    style << error_style_for_attr(options[:details_attr])
    choices = options.fetch(:choices) { object.toggle_choices }
    data = options[:data] || { 'toggle-field' => object.toggle_field }
    content_tag(:div, class: 'form-group js-show-hide') do
      safe_join([
        content_tag(:div, class: 'controls-optional-section', data: data) do
          radio_button_fieldset attribute,
            choices: choices, inline: options.fetch(:inline_choices, true)
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

  def field_without_label(field_type, attribute)
    content_tag :div,
      class: form_group_classes(attribute.to_sym),
      id: form_group_id(attribute) do
      field_tag =
        field_type.new(
          object.class.name, attribute, self,
          value: object.public_send(attribute), class: 'form-control'
        ).render
      hint_tag = content_tag(:span, hint_text(attribute), class: 'form-hint')
      (hint_tag + field_tag).html_safe
    end
  end

  def search_text_field(attribute)
    ActionView::Helpers::Tags::TextField.new(
      object.class.name, attribute, self,
      value: object.public_send(attribute), class: 'form-control'
    ).render
  end

  def text_area_without_label(attribute)
    field_without_label ActionView::Helpers::Tags::TextArea, attribute
  end

  def text_field_without_label(attribute)
    field_without_label ActionView::Helpers::Tags::TextField, attribute
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
    style << ' mps-hide' unless object.public_send("#{attribute}_on?")
    content_tag(:div, class: 'js-checkbox-show-hide form-group') do
      label(attribute, class: 'block-label') do
        content_tag(:div, class: 'controls-optional-checkbox-section') do
          check_box attribute
        end +
          localized_label(attribute)
      end
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
end
