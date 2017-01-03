require 'rails_helper'

RSpec.describe Forms::Risk::ConcealedWeapons, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      'conceals_weapons' => 'yes',
      'conceals_weapons_details' => 'Guns and rifles',
      'conceals_drugs' => 'yes',
      'conceals_drugs_details' => 'Guns and rifles',
      'conceals_mobile_phone_or_other_items' => 'yes',
      'conceals_mobile_phones' => '1',
      'conceals_sim_cards' => '1',
      'conceals_other_items' => '1',
      'conceals_other_items_details' => 'Other items'
    }
  }

  describe '#validate' do
    shared_examples_for 'valid form' do
      it 'no error is added to the error list' do
        expect(form).to be_valid
        expect(form.errors.keys).to be_empty
      end
    end

    it { is_expected.to validate_optional_details_field(:conceals_weapons) }
    it { is_expected.to validate_optional_details_field(:conceals_drugs) }

    context 'conceals_mobile_phone_or_other_items' do
      it { is_expected.to validate_optional_field(:conceals_mobile_phone_or_other_items) }

      it do
        is_expected.to be_configured_to_reset(%i[
          conceals_mobile_phones conceals_sim_cards
          conceals_other_items conceals_other_items_details
        ]).when(:conceals_mobile_phone_or_other_items).not_set_to('yes')
      end

      it { is_expected.to be_configured_to_reset([:conceals_other_items_details]).when(:conceals_other_items).not_set_to(true) }

      context 'when is set to unknown' do
        before { form.conceals_mobile_phone_or_other_items = 'unknown' }
        include_examples 'valid form'
      end

      context 'when is set to no' do
        before { form.conceals_mobile_phone_or_other_items = 'no' }
        include_examples 'valid form'
      end

      context 'when is set to yes' do
        before { form.conceals_mobile_phone_or_other_items = 'yes' }

        context 'and no type concealed other items is selected' do
          before do
            form.conceals_mobile_phones = false
            form.conceals_sim_cards = false
            form.conceals_other_items = false
          end

          let(:attr_with_error) { :base }
          let(:error_message) { 'At least one option (Mobile phones, SIM cards, Other) needs to be provided' }

          it { is_expected.not_to validate_presence_of(:conceals_other_items_details) }

          it 'inclusion error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'and other concealed items is set to true' do
          before { form.conceals_other_items = true }

          it { is_expected.to validate_presence_of(:conceals_other_items_details) }
        end
      end
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
