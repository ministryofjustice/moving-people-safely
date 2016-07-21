require 'rails_helper'

RSpec.describe Forms::Risk::SubstanceMisuse, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'drugs' => 'yes',
      'drugs_details' => 'Heroin use',
      'alcohol' => 'yes',
      'alcohol_details' => 'Lots of beer',
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:drugs) }
    it { is_expected.to validate_optional_details_field(:alcohol) }
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
