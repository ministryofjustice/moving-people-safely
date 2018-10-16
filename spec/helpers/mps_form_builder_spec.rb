require 'rails_helper'

RSpec.describe MpsFormBuilder do
  subject { MpsFormBuilder.new(object_name, object, template, {}) }

  let(:object_name) { 'an_obj' }
  let(:template) { ActionView::Base.new }
  let(:block_content) { 'some content' }
  let(:object_class) { double('My Object class', name: object_name)}
  let(:attribute_value) { 'a value' }

  def squish(str)
    # Remove all whitespace to make HTML comparison easy
    str.gsub(/\s/, '')
  end

  shared_examples :correctly_renders do
    it 'correctly renders HTML' do
      expect(squish(rendering)).to eq(squish(html))
    end
  end

  describe '#custom_check_box_fieldset' do
    let(:object) { double('My Object', my_attribute: attribute_value) }
    let(:rendering) { subject.custom_check_box_fieldset(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="govuk-form-group">
          <div class="multiple-choice">
            <input name="#{object_name}[my_attribute]" type="hidden" value="0" />
            <input type="checkbox" value="1" name="#{object_name}[my_attribute]" id="#{object_name}_my_attribute" />
            <label for="#{object_name}_my_attribute">My attribute</label>
          </div>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#error_messages' do
    let(:object) { double('My Object', errors: errors) }

    let(:errors) do
      double('Errors', keys: [:att1], full_messages_for: [error_message])
    end

    let(:title) { 'A title' }
    let(:description) { 'A description' }
    let(:error_message) { 'An error message' }
    let(:rendering) { subject.error_messages(title: title,
      description: description) }

    let(:html) do
      <<-HTML
        <div class="govuk-error-summary" role="alert" aria-labelledby="error-summary-title" tabindex="-1" data-module="error-summary">
          <h2 id="error-summary-title" class="govuk-error-summary__title">
            #{title}
          </h2>
          <p>#{description}</p>
          <div class="govuk-error-summary__body">
            <ul class="govuk-list govuk-error-summary__list">
              <li>
                <a href="#error_an_obj_att1">#{error_message}</a>
              </li>
            </ul>
          </div>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#text_area_without_label' do
    let(:object) do
      double('My Object', my_attribute: attribute_value, name: 'my_name')
    end

    let(:rendering) { subject.text_area_without_label(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="govuk-form-group">
          <label for="my_name_my_attribute" class="govuk-hint govuk-label"></label>
          <textarea class="govuk-textarea govuk-!-width-one-half" name="my_name[my_attribute]" id="my_name_my_attribute">
            #{attribute_value}
          </textarea>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#text_field_without_label' do
    let(:object) do
      double('My Object', my_attribute: attribute_value, name: 'my_name')
    end

    let(:rendering) { subject.text_field_without_label(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="govuk-form-group">
          <label for="my_name_my_attribute" class="govuk-hint govuk-label"></label>
          <input value="#{attribute_value}" class="govuk-input govuk-!-width-one-quarter" type="text" name="my_name[my_attribute]" id="my_name_my_attribute" />
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end
end
