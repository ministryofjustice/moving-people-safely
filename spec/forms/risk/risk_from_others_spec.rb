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
    its(:rule_45) { is_expected.to eq 'unknown' }
    its(:csra) { is_expected.to eq 'unknown' }
    its(:verbal_abuse) { is_expected.to eq 'unknown' }
    its(:physical_abuse) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it do
      is_expected.
        to validate_inclusion_of(:rule_45).
        in_array(%w[ yes no unknown ])
    end

    context 'when rule_45 is set to yes' do
      before { subject.rule_45 = 'yes' }
      it { is_expected.to validate_presence_of(:rule_45_details) }
    end

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

    it do
      is_expected.
        to validate_inclusion_of(:verbal_abuse).
        in_array(%w[ yes no unknown ])
    end

    context 'when verbal_abuse is set to yes' do
      before { subject.verbal_abuse = 'yes' }
      it { is_expected.to validate_presence_of(:verbal_abuse_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:physical_abuse).
        in_array(%w[ yes no unknown ])
    end

    context 'when physical_abuse is set to yes' do
      before { subject.physical_abuse = 'yes' }
      it { is_expected.to validate_presence_of(:physical_abuse_details) }
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
