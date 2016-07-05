require 'rails_helper'

RSpec.describe Forms::Risks::NonAssociationMarkers, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'non_association_markers' => 'yes',
      'non_association_markers_details' => 'Prisoner A1234BC and Z9876XY'
    }
  }

  describe 'defaults' do
    its(:non_association_markers) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ non_association_markers_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:non_association_markers).
        in_array(%w[ yes no unknown ])
    end

    context 'when non_association_markers is set to yes' do
      before { subject.non_association_markers = 'yes' }
      it { is_expected.to validate_presence_of(:non_association_markers_details) }
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
