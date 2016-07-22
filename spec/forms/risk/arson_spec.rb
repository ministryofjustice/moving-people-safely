require 'rails_helper'

RSpec.describe Forms::Risk::Arson, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'arson' => 'yes',
      'arson_value' => 'high',
      'arson_details' => 'Burnt entire forests',
      'damage_to_property' => 'yes',
      'damage_to_property_details' => 'Several garages',
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:damage_to_property) }
    it { is_expected.to validate_optional_details_field(:arson) }
    it { is_expected.to validate_inclusion_of(:arson_value).in_array(%w[ high medium low ]) }
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
