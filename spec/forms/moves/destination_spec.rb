require 'rails_helper'

RSpec.describe Forms::Moves::Destination, type: :form do
  let(:model) { Destination.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      establishment: 'Bedford',
      must_return: 'must_return',
      reasons: 'Violence',
      _delete: '0'
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:must_return) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ establishment must_return reasons ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it 'coerces params' do
      coerced_params = params.merge(_delete: false)
      subject.validate(params)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it { is_expected.to validate_presence_of(:establishment) }

    it do
      is_expected.
        to validate_inclusion_of(:must_return).
        in_array(subject.must_return_values)
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

