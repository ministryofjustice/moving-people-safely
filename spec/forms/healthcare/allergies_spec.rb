require 'rails_helper'

RSpec.describe Forms::Healthcare::Allergies, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      allergies: 'yes',
      allergies_details: 'Nuts',
    }.with_indifferent_access
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:allergies) }
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
