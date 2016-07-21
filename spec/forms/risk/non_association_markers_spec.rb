require 'rails_helper'

RSpec.describe Forms::Risk::NonAssociationMarkers, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'non_association_markers' => 'yes',
      'non_association_markers_details' => 'Prisoner A1234BC and Z9876XY'
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:non_association_markers) }
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
