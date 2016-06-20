class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  def radio_toggle(attribute, &_blk)
    style = 'optional-section-wrapper panel panel-border-narrow'
    content_tag(:div, class: 'js_multiples') do
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
end
