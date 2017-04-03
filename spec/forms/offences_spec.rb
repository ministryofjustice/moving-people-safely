require 'rails_helper'

RSpec.describe Forms::Offences, type: :form do
  let(:model) { Offences.new }
  subject { described_class.new(model) }

  let(:form_data) do
    {
      'current_offences' => [
        {
          'offence' => 'Burglary',
          'case_reference' => 'AX123456',
          '_delete' => '0'
        }
      ]
    }
  end

  describe "#validate" do
    let(:coerced_params) do
      {
        'current_offences' => [
          'offence' => 'Burglary',
          'case_reference' => 'AX123456',
          '_delete' => false
        ]
      }
    end

    it 'coerces params' do
      subject.validate(form_data)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it { is_expected.to validate_prepopulated_collection :current_offences }
  
    specify { expect(subject.validate(form_data)).to eq(true) }
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(form_data)
      subject.save

      form_attributes_without_nested_forms =
        subject.to_nested_hash.except(:current_offences)
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
    end

    def current_offences_without_virtual_attributes(form)
      form.to_nested_hash[:current_offences].each { |d| d.delete(:_delete) }
    end
  end
end
