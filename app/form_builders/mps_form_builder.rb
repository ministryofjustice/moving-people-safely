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
    GovukElementsErrorsHelper.error_summary(object, title, description,
      as: object_name)
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
    content_tag :div, class: 'form-group' do
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
      text_area_without_label details_attr
    end
  end

  def date_picker_text_field(attribute, options = {})
    content_tag :div,
      class: form_group_classes(attribute.to_sym) + ' date-picker-wrapper',
      id: form_group_id(attribute) do
        set_field_classes! options, attribute

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
      { value: object.public_send(attribute),
        class: 'form-control' }.merge(options)
    ).render
  end

  def text_area_without_label(attribute)
    field_without_label ActionView::Helpers::Tags::TextArea, attribute
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

  def text_field_for_role(attribute, options = {})
    object_sym = object.name.underscore.to_sym
    label_scope = [:helpers, :label, object_sym, attribute]
    hint_scope = [:helpers, :hint, object_sym, attribute]
    role = options.fetch(:role, :prison)
    label_text = GovukElementsFormBuilder::FormBuilder.translate(role, '', label_scope)
    hint_text = GovukElementsFormBuilder::FormBuilder.translate(role, '', hint_scope)

    content_tag :div, class: form_group_classes(attribute.to_sym),
                      id: form_group_id(attribute) do
      text_field_for_role_tags(attribute, label_text, hint_text, options)
    end
  end

  private

  def text_field_for_role_tags(attribute, label_text, hint_text, options)
    [
      label(attribute, label_text, class: 'form-label'),
      (content_tag(:span, hint_text, class: 'form-hint') if hint_text.present?),
      (error_message_tag_for_attr(attribute) if error_for?(attribute)),
      ActionView::Helpers::Tags::TextField.new(
        object_name, attribute, self,
        { value: object.public_send(attribute), class: 'form-control' }.merge(options)
      ).render
    ].compact.join.html_safe
  end

  def custom_text_field(attribute, options = {})
    ActionView::Helpers::Tags::TextField.new(
      object.class.name, attribute, self,
      { value: object.public_send(attribute),
        class: 'form-control' }.merge(options)
    ).render
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

  def radio_options(choice, id_postfix)
    id_postfix ? { id: choice.to_s + id_postfix.to_s } : {}
  end

  def label_options(value, choice, id_postfix)
    { value: value }.tap do |options|
      options.merge!(for: choice.to_s + id_postfix.to_s) if id_postfix
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
          { value: object.public_send(attribute),
            class: 'form-control' }.merge(options)
        ).render
      tags.join.html_safe
    end
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
