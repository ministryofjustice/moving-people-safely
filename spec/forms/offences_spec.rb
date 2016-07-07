require 'rails_helper'

RSpec.describe Forms::Offences, type: :form do
  let(:escort) { Escort.create }
  let(:model) { Offences.new(escort: escort) }
  subject { described_class.new(model) }

  let(:form_data) do
    {
      'release_date' => '15/09/2027',
      'not_for_release' => 'yes',
      'not_for_release_details' => 'remember what happened last time?',
      'current_offences' => [
        {
          'offence' => 'Burglary',
          'case_reference' => 'AX123456',
          '_delete' => '0'
        }
      ],
      'has_past_offences' => 'yes',
      'past_offences' => [
        {
          'offence' => 'More Burglary',
          '_delete' => '0'
        }
      ]
    }
  end

  describe "#validate" do
    let(:coerced_params) do
      {
        'release_date' => Date.new(2027, 9, 15),
        'not_for_release' => true,
        'not_for_release_details' => 'remember what happened last time?',
        'current_offences' => [
          'offence' => 'Burglary',
          'case_reference' => 'AX123456',
          '_delete' => false
        ],
        'has_past_offences' => 'yes',
        'past_offences' => [
          'offence' => 'More Burglary',
          '_delete' => false
        ]
      }
    end

    it 'coerces params' do
      subject.validate(form_data)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it { is_expected.to validate_presence_of(:release_date) }
    it { is_expected.to validate_string_as_date(:release_date) }
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(form_data)
      subject.save

      form_attributes_without_nested_forms =
        subject.to_nested_hash.except(:current_offences, :past_offences)
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes_without_nested_forms
    end

    it 'sets the data on nested models' do
      subject.validate(form_data)
      subject.save

      model_current_offences = subject.model.current_offences.map(&:attributes)
      form_current_offences =
        current_offences_without_virtual_attributes(subject)

      model_current_offences.each_with_index do |md, index|
        expect(md).to include form_current_offences[index]
      end

      model_past_offences = subject.model.past_offences.map(&:attributes)
      form_past_offences = past_offences_without_virtual_attrs(subject)
      model_past_offences.each_with_index do |md, index|
        expect(md).to include form_past_offences[index]
      end
    end

    def past_offences_without_virtual_attrs(form)
      form.to_nested_hash[:past_offences].each { |d| d.delete(:_delete) }
    end

    def current_offences_without_virtual_attributes(form)
      form.to_nested_hash[:current_offences].each { |d| d.delete(:_delete) }
    end
  end
end
