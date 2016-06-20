class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  def radio_toggle(attribute, &_blk)
    style = 'optional-section-wrapper panel panel-border-narrow'
    content_tag(:div, class: 'js-show-hide') do
      safe_join([
        content_tag(:div, class: 'form-group controls-optional-section') do
          radio_button_fieldset attribute,
            choices: object.toggle_choices, inline: true
        end,
        content_tag(:div, class: style) { yield }
      ], "\n")
    end
  end

  def radio_toggle_with_textarea(attribute)
    radio_toggle(attribute) { text_area "#{attribute}_details" }
  end

  def label_with_radio(attribute, text, value)
    label(attribute, value: value, class: 'block-label') do
      safe_join([text, radio_button(attribute, value)])
    end
  end
end
