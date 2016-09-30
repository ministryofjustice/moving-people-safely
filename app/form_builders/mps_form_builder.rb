class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  def radio_toggle(attribute, attribute_with_error = nil, choices = nil, &_blk)
    style = 'optional-section-wrapper'
    style << ' mps-hide' unless object.public_send("#{attribute}").try :on? # FIXME
    style << ' panel panel-border-narrow' unless error_for? attribute_with_error
    style << ' toggle_with_error' if error_for? attribute_with_error
    choices ||= object.public_send(attribute).try :toggle_choices # FIXME
    name = Considerations::Naming.namespaced_method_name(attribute, "option")
    content_tag(:div, class: 'form-group js-show-hide') do
      safe_join([
        content_tag(:div, class: 'controls-optional-section') do
          radio_button_fieldset name, choices: choices, inline: true
        end,
        (content_tag(:div, class: style) { yield } if block_given?)
      ])
    end
  end

  def radio_toggle_with_textarea(attribute)
    attribute_details = Considerations::Naming.namespaced_method_name(attribute, "details")
    radio_toggle(attribute, attribute_details) do
      #text_area_without_label attribute_details
      text_area_without_label attribute
    end
  end

  def field_without_label(field_type, attribute)
    attribute_details = Considerations::Naming.namespaced_method_name(attribute, "details")
    content_tag :div,
      class: attribute,
      id: attribute do
      field_tag =
        field_type.new(
          attribute, attribute_details, self,
          value: object.public_send(attribute).details, class: 'form-control'
        ).render
      hint_tag = content_tag(:span, hint_text(attribute), class: 'form-hint')
      (hint_tag + field_tag).html_safe
    end
  end

  def search_text_field(attribute)
    ActionView::Helpers::Tags::TextField.new(
      'search', attribute, self,
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
