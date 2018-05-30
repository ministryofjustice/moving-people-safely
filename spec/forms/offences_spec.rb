require 'rails_helper'

RSpec.describe Forms::Offences, type: :form do
  let(:model) { Escort.new(offences: []) }
  subject { described_class.new(model) }

  let(:form_data) do
    {
      'offences' => [
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
        'offences' => [
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

    it { is_expected.to validate_prepopulated_collection :offences }

    specify { expect(subject.validate(form_data)).to eq(true) }
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(form_data)
      subject.save

      form_attributes_without_nested_forms =
        subject.to_nested_hash.except(:offences)
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes_without_nested_forms
    end

    it 'sets the data on nested models' do
      subject.validate(form_data)
      subject.save

      model_offences = subject.model.offences.map(&:attributes)
      form_offences = offences_without_virtual_attributes(subject)

      model_offences.each_with_index do |md, index|
        expect(md).to include form_offences[index]
      end
    end

    def offences_without_virtual_attributes(form)
      form.to_nested_hash[:offences].each { |d| d.delete(:_delete) }
    end
  end
end
