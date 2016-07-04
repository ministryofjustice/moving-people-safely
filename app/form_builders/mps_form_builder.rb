class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  def radio_toggle(attribute, attribute_with_error = nil, choices = nil, &_blk)
    style = 'optional-section-wrapper'
    style << ' panel panel-border-narrow' unless error_for? attribute_with_error
    choices ||= object.toggle_choices
    content_tag(:div, class: 'js-show-hide') do
      safe_join([
        content_tag(:div, class: 'form-group controls-optional-section') do
          radio_button_fieldset attribute,
            choices: choices, inline: true
        end,
        content_tag(:div, class: style) { yield }
      ])
    end
  end

  def radio_toggle_with_textarea(attribute)
    attribute_details = :"#{attribute}_details"
    radio_toggle(attribute, attribute_details) do
      text_area_without_label attribute_details
    end
  end

  def text_area_without_label(attribute)
    content_tag :div,
      class: form_group_classes(attribute),
      id: form_group_id(attribute) do
      text_area_tag =
        ActionView::Helpers::Tags::TextArea.new(
          object.class.name, attribute, self,
          value: object.public_send(attribute), class: 'form-control'
        ).render
      hint_tag = content_tag(:span, hint_text(attribute), class: 'form-hint')
      (hint_tag + text_area_tag).html_safe
    end
  end

  def label_with_radio(attribute, text, value)
    label(attribute, value: value, class: 'block-label') do
      safe_join([text, radio_button(attribute, value)])
    end
  end

  def checkbox_with_textarea(attribute)
    content_tag(:div, class: 'js-checkbox-show-hide form-group') do
      label(attribute, class: 'block-label') do
        content_tag(:div, class: 'controls-optional-checkbox-section') do
          check_box attribute
        end +
          localized_label(attribute)
      end +
        content_tag(:div, class: 'optional-checkbox-section-wrapper') do
          text_area_without_label "#{attribute}_details"
        end
    end
  end
end
