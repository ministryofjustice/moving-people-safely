require 'rails_helper'

RSpec.describe Forms::Risk::Arson, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'arson' => 'yes',
      'damage_to_property' => 'yes'
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_field(:damage_to_property) }
    it { is_expected.to validate_optional_field(:arson) }
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
