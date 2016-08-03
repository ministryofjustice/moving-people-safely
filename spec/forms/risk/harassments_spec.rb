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

      it {
        is_expected.
          to validate_attributes_are_reset(
            :hostage_taker, :hostage_taker_details, :stalker, :stalker_details, :harasser,
            :harasser_details, :intimidator, :intimidator_details, :bully, :bully_details).
          when_attribute_is_disabled(:stalker_harasser_bully)
      }

      context 'when stalker_harasser_bully is set to yes' do
        before { subject.stalker_harasser_bully = 'yes' }

        # TODO this smells of needing a checkbox validator
        %w[ hostage_taker stalker harasser intimidator bully ].each do |field|
          context "when #{field} is set to true" do
            before { subject.public_send("#{field}=", true) }
            it { is_expected.to validate_presence_of("#{field}_details") }
          end
        end
      end
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
