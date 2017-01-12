require 'rails_helper'

RSpec.describe Forms::Risk::SubstanceMisuse, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      'substance_supply' => 'yes',
      'trafficking_drugs' => '1',
      'trafficking_alcohol' => '1'
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_field(:substance_supply) }

    context 'when substance_supply is set to yes' do
      before { form.substance_supply = 'yes' }

      context 'but none of the checkboxes is selected' do
        before do
          form.trafficking_drugs = false
          form.trafficking_alcohol = false
        end

        it 'an invalid date error is added to the error list' do
          expect(form).not_to be_valid
          expect(form.errors.keys).to match_array([:base])
          expect(form.errors[:base]).to match_array(['At least one option (Drugs, Alcohol) needs to be provided'])
        end
      end
    end

    it do
      is_expected.to be_configured_to_reset(%i[
        trafficking_drugs trafficking_alcohol
      ]).when(:substance_supply).not_set_to('yes')
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
