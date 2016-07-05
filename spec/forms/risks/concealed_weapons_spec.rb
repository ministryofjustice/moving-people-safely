require 'rails_helper'

RSpec.describe Forms::Risks::ConcealedWeapons, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'conceals_weapons' => 'yes',
      'conceals_weapons_details' => 'Guns and rifles',
    }
  }

  describe 'defaults' do
    its(:conceals_weapons) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ conceals_weapons_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:conceals_weapons).
        in_array(%w[ yes no unknown ])
    end

    context 'when conceals_weapons is set to yes' do
      before { subject.conceals_weapons = 'yes' }
      it { is_expected.to validate_presence_of(:conceals_weapons_details) }
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
