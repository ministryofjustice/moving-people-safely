require 'rails_helper'

RSpec.describe Forms::Risks::NonAssociationMarkers, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      non_association: 'yes',
      non_association_markers: [
        details: 'Detainee 1234',
        _delete: '0'
      ]
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:non_association) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
    end

    it do
      is_expected.
        to validate_inclusion_of(:non_association).
        in_array(%w[ yes no unknown ])
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes_without_nested_forms = subject.to_nested_hash.except(:non_association_markers)
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes_without_nested_forms
    end
  end
end
