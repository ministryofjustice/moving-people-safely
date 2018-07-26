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

  describe '#custom_radio_button_fieldset' do
    let(:object) { double('My Object', my_attribute: attribute_value) }
    let(:rendering) { subject.custom_radio_button_fieldset(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="form-group">
          <fieldset>
            <legend>
              <span class="form-label-bold">My attribute</span>
            </legend>
            <div class="multiple-choice">
              <input type="radio" value="yes" name="#{object_name}[my_attribute]" id="#{object_name}_my_attribute_yes" />
              <label for="#{object_name}_my_attribute_yes">Yes</label>
            </div>
            <div class="multiple-choice">
              <input type="radio" value="no" name="#{object_name}[my_attribute]" id="#{object_name}_my_attribute_no" />
              <label for="#{object_name}_my_attribute_no">No</label>
            </div>
          </fieldset>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#radio_toggle' do
    let(:object) do
      double('My Object', my_attribute: attribute_value, my_attribute_on?: true,
        toggle_field: 'my_toggle_field', toggle_choices: [:bish, :bosh])
    end

    let(:rendering) do
      subject.radio_toggle(:my_attribute, {}) { block_content }
    end

    let(:html) do
      <<-HTML
        <div class="form-group js-show-hide">
          <div class="controls-optional-section" data-toggle-field="my_toggle_field">
            <div class="form-group">
              <fieldset class="inline">
                <legend>
                  <span class="form-label-bold">My attribute</span>
                </legend>
                <div class="multiple-choice">
                  <input type="radio" value="bish" name="#{object_name}[my_attribute]" id="#{object_name}_my_attribute_bish" />
                  <label for="#{object_name}_my_attribute_bish">Bish</label>
                </div>
                <div class="multiple-choice">
                  <input type="radio" value="bosh" name="#{object_name}[my_attribute]" id="#{object_name}_my_attribute_bosh" />
                  <label for="#{object_name}_my_attribute_bosh">Bosh</label>
                </div>
              </fieldset>
            </div>
          </div>
          <div class="optional-section-wrapper mps-hide panel panel-border-narrow">
            #{block_content}
          </div>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#radio_concertina_option' do
    let(:object) { double('My Object', my_attribute: attribute_value) }
    let(:option) { 'my_option' }
    let(:label)  { 'My option' }

    let(:rendering) do
      subject.radio_concertina_option(:my_attribute, option) do
        block_content
      end
    end

    let(:html) do
      <<-HTML
        <div class="multiple-choice">
          <input id="my_option_toggler" type="radio" value="#{option}" name="#{object_name}[my_attribute]" />
          <label for="my_option_toggler">#{label}</label>
        </div>
        <div class="panel panel-border-narrow" data-toggled-by="my_option_toggler">
          #{block_content}
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#custom_check_box_fieldset' do
    let(:object) { double('My Object', my_attribute: attribute_value) }
    let(:rendering) { subject.custom_check_box_fieldset(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="form-group">
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
        <div class="error-summary" role="group" aria-labelledby="error-summary-heading" tabindex="-1">
          <h1 id="error-summary-heading" class="heading-medium error-summary-heading">
            #{title}
          </h1>
          <p>#{description}</p>
          <ul class="error-summary-list">
            <li>
              <a href="#error_an_obj_att1">#{error_message}</a>
            </li>
          </ul>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#radio_toggle_with_textarea' do
    let(:object) do
      double('My Object', my_attribute: attribute_value,
        toggle_field: 'my_toggle_field',
        toggle_choices: [:bish, :bosh], name: 'my_name',
        my_attribute_details: 'My details')
    end

    let(:rendering) { subject.radio_toggle_with_textarea(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="form-group js-show-hide">
          <div class="controls-optional-section" data-toggle-field="my_toggle_field">
            <div class="form-group">
              <fieldset class="inline">
                <legend>
                  <span class="form-label-bold">My attribute</span>
                </legend>
                <div class="multiple-choice">
                  <input type="radio" value="bish" name="an_obj[my_attribute]" id="an_obj_my_attribute_bish" />
                  <label for="an_obj_my_attribute_bish">Bish</label>
                </div>
                <div class="multiple-choice">
                  <input type="radio" value="bosh" name="an_obj[my_attribute]" id="an_obj_my_attribute_bosh" />
                  <label for="an_obj_my_attribute_bosh">Bosh</label>
                </div>
              </fieldset>
            </div>
          </div>
          <div class="optional-section-wrapper mps-hide panel panel-border-narrow">
            <div class="form-group">
              <span class="form-hint"></span>
              <textarea class="form-control form-control-3-4" name="my_name[my_attribute_details]" id="my_name_my_attribute_details">
                My details
              </textarea>
            </div>
          </div>
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end

  describe '#date_picker_text_field' do
    let(:object) { double('My Object', my_attribute: attribute_value, class: object_class) }
    let(:rendering) { subject.date_picker_text_field(:my_attribute) }

    let(:html) do
      <<-HTML
        <div class="form-group date-picker-wrapper">
          <label class="form-label" for="an_obj_my_attribute">My attribute</label>
          <span class="date-picker-field input-group date" data-provide="datepicker">
            <input value="#{attribute_value}" class="no-script form-control date-field" type="text" name="#{object_name}[my_attribute]" id="#{object_name}_my_attribute" />
            <span class="no-script calendar-icon input-group-addon"></span>
          </span>
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
        <div class="form-group">
          <span class="form-hint"></span>
          <textarea class="form-control" name="my_name[my_attribute]" id="my_name_my_attribute">
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
        <div class="form-group">
          <span class="form-hint"></span>
          <input value="#{attribute_value}" class="form-control" type="text" name="my_name[my_attribute]" id="my_name_my_attribute" />
        </div>
      HTML
    end

    it_behaves_like :correctly_renders
  end
end
