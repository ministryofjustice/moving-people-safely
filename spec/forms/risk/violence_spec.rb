require 'rails_helper'

RSpec.describe Forms::Risk::Violence, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  describe '#validate' do
    context "for violence due to discrimination" do
      it { is_expected.to validate_optional_field(:violence_due_to_discrimination) }

      context 'when violent due to discrimination is set to yes' do
        before { form.violence_due_to_discrimination = 'yes' }

        context 'when racist is set to true' do
          before { subject.racist = true }
          it { is_expected.to validate_presence_of(:racist_details) }
        end

        context 'when other violence due to discrimination is set to true' do
          before { subject.other_violence_due_to_discrimination = true }
          it { is_expected.to validate_presence_of(:other_violence_due_to_discrimination_details) }
        end
      end

      it do
        is_expected.to be_configured_to_reset(%i[
          risk_to_females homophobic racist racist_details
          other_violence_due_to_discrimination other_violence_due_to_discrimination_details
        ]).when(:violence_due_to_discrimination).not_set_to('yes')
      end

      describe 'details fields associated with checkboxes' do
        it { is_expected.not_to be_configured_to_reset([:risk_to_females_details]).when(:risk_to_females).not_set_to(true) }
        it { is_expected.not_to be_configured_to_reset([:homophobic_details]).when(:homophobic).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:racist_details]).when(:racist).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:other_violence_due_to_discrimination_details]).when(:other_violence_due_to_discrimination).not_set_to(true) }
      end
    end

    context "for violence to staff" do
      it { is_expected.to validate_optional_field(:violence_to_staff) }

      it do
        is_expected.to be_configured_to_reset(%i[
          violence_to_staff_custody violence_to_staff_community
        ]).when(:violence_to_staff).not_set_to('yes')
      end
    end

    context "for violence to other detainees" do
      it { is_expected.to validate_optional_field(:violence_to_other_detainees) }

      context 'when violent to other detainees is set to yes' do
        before { form.violence_to_other_detainees = 'yes' }

        context 'when co-defendant is set to true' do
          before { subject.co_defendant = true }
          it { is_expected.to validate_presence_of(:co_defendant_details) }
        end

        context 'when gang member is set to true' do
          before { subject.gang_member = true }
          it { is_expected.to validate_presence_of(:gang_member_details) }
        end

        context 'when other violence to other detainees is set to true' do
          before { subject.other_violence_to_other_detainees = true }
          it { is_expected.to validate_presence_of(:other_violence_to_other_detainees_details) }
        end
      end

      it do
        is_expected.to be_configured_to_reset(%i[
          co_defendant co_defendant_details gang_member gang_member_details other_violence_to_other_detainees other_violence_to_other_detainees_details
        ]).when(:violence_to_other_detainees).not_set_to('yes')
      end

      describe 'details fields associated with checkboxes' do
        it { is_expected.not_to be_configured_to_reset([:risk_to_females_details]).when(:risk_to_females).not_set_to(true) }
        it { is_expected.not_to be_configured_to_reset([:homophobic_details]).when(:homophobic).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:racist_details]).when(:racist).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:other_violence_due_to_discrimination_details]).when(:other_violence_due_to_discrimination).not_set_to(true) }
      end
    end

    context "for violence to general public" do
      it { is_expected.to validate_optional_details_field(:violence_to_general_public) }
    end
  end

  describe '#save' do
    let(:params) {
      {
        'violence_due_to_discrimination' => 'yes',
        'risk_to_females' => '1',
        'homophobic' => '1',
        'racist' => '0',
        'other_violence_due_to_discrimination' => '1',
        'other_violence_due_to_discrimination_details' => 'police discrimination',
        'violence_to_staff' => 'yes',
        'violence_to_staff_custody' => '1',
        'violence_to_staff_community' => '0',
        'violence_to_other_detainees' => 'yes',
        'co_defendant' => '1',
        'co_defendant_details' => 'co-defendant details',
        'gang_member' => '1',
        'gang_member_details' => 'Yakusa member',
        'other_violence_to_other_detainees' => '0',
        'violence_to_general_public' => 'yes',
        'violence_to_general_public_details' => 'attacks random people in public'
      }
    }

    it 'sets the data on the model' do
      form.validate(params)
      form.save

      form_attributes = form.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include(form_attributes)
    end
  end
end
