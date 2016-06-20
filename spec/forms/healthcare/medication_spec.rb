require 'rails_helper'

RSpec.describe Forms::Healthcare::Medication, type: :form do
  let(:model) { Medication.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      description: 'Aspirin',
      administration: 'Once a day',
      carrier: 'detainee',
      _delete: '0'
    }.with_indifferent_access
  }

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ description administration ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it 'coerces params' do
      coerced_params = params.merge(_delete: false)
      subject.validate(params)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it { is_expected.to validate_presence_of(:description) }

    it do
      is_expected.
        to validate_inclusion_of(:carrier).
        in_array(%w[ detainee escort ])
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes_without_virtual_attributes = subject.to_nested_hash.
        except(:_delete)

      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes_without_virtual_attributes
    end
  end
end
