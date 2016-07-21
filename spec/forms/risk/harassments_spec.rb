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

  describe 'defaults' do
    its(:stalker_harasser_bully) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ stalker_harasser_bully ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:stalker_harasser_bully).
        in_array(%w[ yes no unknown ])
    end

    context 'when stalker_harasser_bully is set to yes' do
      before { subject.stalker_harasser_bully = 'yes' }

      %w[ hostage_taker stalker harasser intimidator bully ].each do |field|
        context "when #{field} is set to true" do
          before { subject.public_send("#{field}=", true) }
          it { is_expected.to validate_presence_of("#{field}_details") }
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
