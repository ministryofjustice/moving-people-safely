require 'rails_helper'

RSpec.describe Forms::Risk::SubstanceMisuse, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      'substance_supply' => 'yes',
      'substance_supply_details' => 'drugs',
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_field(:substance_supply) }
    it do
      is_expected.to be_configured_to_reset(%i[substance_supply_details])
        .when(:substance_supply).not_set_to('yes')
    end

    context 'when substance_supply is set to unknown' do
      before { form.substance_supply = 'unknown' }
      it {
        is_expected.not_to validate_inclusion_of(:substance_supply_details)
          .in_array(%w[drugs alcohol both])
      }
    end

    context 'when substance_supply is set to no' do
      before { form.substance_supply = 'no' }
      it {
        is_expected.not_to validate_inclusion_of(:substance_supply_details)
          .in_array(%w[drugs alcohol both])
      }
    end

    context 'when substance_supply is set to yes' do
      before { form.substance_supply = 'yes' }
      it {
        is_expected.to validate_inclusion_of(:substance_supply_details)
          .in_array(%w[drugs alcohol both])
      }
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      form.validate(params)
      form.save

      form_attributes = form.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
