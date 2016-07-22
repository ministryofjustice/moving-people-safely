require 'rails_helper'

RSpec.describe Forms::Risk::ConcealedWeapons, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'conceals_weapons' => 'yes',
      'conceals_weapons_details' => 'Guns and rifles',
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:conceals_weapons) }
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
