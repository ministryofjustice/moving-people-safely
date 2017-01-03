require 'rails_helper'

RSpec.describe Forms::Risk::Harassments, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  describe '#validate' do
    context "for harassment" do
      it { is_expected.to validate_optional_details_field(:harassment) }
    end

    context "for intimidation" do
      it { is_expected.to validate_optional_field(:intimidation) }

      context 'when intimidation is set to yes' do
        before { form.intimidation = 'yes' }

        context 'but none of the checkboxes is selected' do
          before do
            form.intimidation_to_staff = false
            form.intimidation_to_public = false
            form.intimidation_to_other_detainees = false
            form.intimidation_to_witnesses = false
          end

          it 'an invalid date error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([:base])
            expect(form.errors[:base]).to match_array(['At least one option (Staff, Public, Prisoners, Witnesses) needs to be provided'])
          end
        end

        context 'and intimidation to staff is set to true' do
          before { subject.intimidation_to_staff = true }
          it { is_expected.to validate_presence_of(:intimidation_to_staff_details) }
        end

        context 'when intimidation to public is set to true' do
          before { subject.intimidation_to_public = true }
          it { is_expected.to validate_presence_of(:intimidation_to_public_details) }
        end

        context 'when intimidation to other detainees is set to true' do
          before { subject.intimidation_to_other_detainees = true }
          it { is_expected.to validate_presence_of(:intimidation_to_other_detainees_details) }
        end

        context 'when intimidation to witnesses is set to true' do
          before { subject.intimidation_to_witnesses = true }
          it { is_expected.to validate_presence_of(:intimidation_to_witnesses_details) }
        end
      end

      it do
        is_expected.to be_configured_to_reset(%i[
          intimidation_to_staff intimidation_to_staff_details
          intimidation_to_public intimidation_to_public_details
          intimidation_to_other_detainees intimidation_to_other_detainees_details
          intimidation_to_witnesses intimidation_to_witnesses_details
        ]).when(:intimidation).not_set_to('yes')
      end

      describe 'details fields associated with checkboxes' do
        it { is_expected.to be_configured_to_reset([:intimidation_to_staff_details]).when(:intimidation_to_staff).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:intimidation_to_public_details]).when(:intimidation_to_public).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:intimidation_to_other_detainees_details]).when(:intimidation_to_other_detainees).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:intimidation_to_witnesses_details]).when(:intimidation_to_witnesses).not_set_to(true) }
      end
    end
  end

  describe '#save' do
    let(:params) {
      {
        'harassment' => 'yes',
        'harassment_details' => 'harassment details',
        'intimidation' => 'yes',
        'intimidation_to_staff' => '1',
        'intimidation_to_staff_details' => 'intimidation to staff details',
        'intimidation_to_public' => '1',
        'intimidation_to_public_details' => 'intimidation to public details',
        'intimidation_to_other_detainees' => '1',
        'intimidation_to_other_detainees_details' => 'intimidation to other detainees details',
        'intimidation_to_witnesses' => '1',
        'intimidation_to_witnesses_details' => 'intimidation to witnesses details'
      }
    }

    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
