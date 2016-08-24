require 'rails_helper'

RSpec.describe Forms::Risk::Harassments, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'stalker_harasser_bully' => 'yes',
      'intimidator' => '1',
      'intimidator_details' => 'Aggressive personality',
    }
  }

  describe '#validate' do
    context "for the 'stalker_harasser_bully' attribute" do
      it { is_expected.to validate_optional_field(:stalker_harasser_bully) }

      context 'when stalker_harasser_bully is set to yes' do
        before { subject.stalker_harasser_bully = 'yes' }

        %w[ hostage_taker stalker harasser intimidator bully ].each do |field|
          context "when #{field} is set to true" do
            before { subject.public_send("#{field}=", true) }
            it { is_expected.to validate_presence_of("#{field}_details") }
          end
        end
      end

      it do
        is_expected.to be_configured_to_reset(%i[
          hostage_taker hostage_taker_details stalker stalker_details harasser
          harasser_details intimidator intimidator_details bully bully_details
        ]).when(:stalker_harasser_bully).not_set_to('yes')
      end
    end

    describe 'details fields associated with checkboxes' do
      it { is_expected.to be_configured_to_reset(['hostage_taker_details']).when(:hostage_taker).not_set_to(true) }
      it { is_expected.to be_configured_to_reset(['stalker_details']).when(:stalker).not_set_to(true) }
      it { is_expected.to be_configured_to_reset(['harasser_details']).when(:harasser).not_set_to(true) }
      it { is_expected.to be_configured_to_reset(['intimidator_details']).when(:intimidator).not_set_to(true) }
      it { is_expected.to be_configured_to_reset(['bully_details']).when(:bully).not_set_to(true) }
    end
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
