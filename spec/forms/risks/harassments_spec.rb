require 'rails_helper'

RSpec.describe Forms::Risks::Harassments, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      hostage_taker_stalker_harasser: 'yes',
      hostage_taker: '1',
      stalker: '1',
      harasser: '1',
      intimidation: '1',
      bullying: '1',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:hostage_taker_stalker_harasser) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ hostage_taker_stalker_harasser ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
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
