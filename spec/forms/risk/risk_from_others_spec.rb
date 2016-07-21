require 'rails_helper'

RSpec.describe Forms::Risk::RiskFromOthers, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'rule_45' => 'yes',
      'rule_45_details' => 'Rule 45 present',
      'csra' => 'high',
      'csra_details' => 'High risk of CSRA',
      'verbal_abuse' => 'yes',
      'verbal_abuse_details' => 'Many verbal abuses',
      'physical_abuse' => 'yes',
      'physical_abuse_details' => 'some physical abuses',
    }
  }

  describe 'defaults' do
    its(:csra) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:rule_45) }
    it { is_expected.to validate_optional_details_field(:verbal_abuse) }
    it { is_expected.to validate_optional_details_field(:physical_abuse) }

    describe 'csra attribute' do
      it do
        is_expected.
          to validate_inclusion_of(:csra).
          in_array(%w[ high standard unknown ])
      end

      context 'when csra is set to high' do
        before { subject.csra = 'high' }
        it { is_expected.to validate_presence_of(:csra_details) }
      end

      context 'when csra is set to standard' do
        before { subject.csra = 'standard' }
        it { is_expected.to validate_presence_of(:csra_details) }
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
