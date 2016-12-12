require 'rails_helper'

RSpec.describe Forms::Risk::RiskFromOthers, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'rule_45' => 'yes',
      'csra' => 'high',
      'victim_of_abuse' => 'yes',
      'victim_of_abuse_details' => 'Many verbal abuses',
      'high_profile' => 'yes',
      'high_profile_details' => 'former TV host',
    }
  }

  describe 'defaults' do
    its(:csra) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it { is_expected.to validate_optional_field(:rule_45) }
    it { is_expected.to validate_optional_details_field(:victim_of_abuse) }
    it { is_expected.to validate_optional_details_field(:high_profile) }

    describe 'csra attribute' do
      it do
        is_expected.
          to validate_inclusion_of(:csra).
          in_array(%w[ high standard unknown ])
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
