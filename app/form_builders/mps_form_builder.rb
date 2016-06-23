class MpsFormBuilder < GovukElementsFormBuilder::FormBuilder
  def radio_toggle(attribute, &_blk)
    content_tag(:div, class: 'js-show-hide') do
      safe_join([
        content_tag(:div, class: 'form-group controls-optional-section') do
          radio_button_fieldset attribute,
            choices: object.toggle_choices, inline: true
        end,
        content_tag(:div, class: 'optional-section-wrapper') { yield }
      ])
    end
  end

  def radio_toggle_with_textarea(attribute)
    radio_toggle(attribute) { text_area :"#{attribute}_details" }
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

  # rubocop:disable MethodLength
  def checkbox_with_textarea(attribute)
    content_tag(:div, class: 'js-checkbox-show-hide form-group') do
      label(attribute, class: 'block-label') do
        content_tag(:div, class: 'controls-optional-checkbox-section') do
          check_box attribute
        end +
          localized_label(attribute)
      end +
        content_tag(:div, class: 'optional-checkbox-section-wrapper') do
          text_area "#{attribute}_details"
        end
    end
  end
  # rubocop:enable MethodLength

  def simple_textarea(attribute)
    content_tag(:div, class: 'js-checkbox-show-hide form-group') do
      label(attribute, class: 'block-label') do
        content_tag(:div, class: 'controls-optional-checkbox-section') do
          check_box attribute
        end +
          localized_label(attribute)
      end
    end
  end
end
