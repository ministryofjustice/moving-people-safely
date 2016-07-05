require 'rails_helper'

RSpec.describe Forms::Risks::Security, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'current_e_risk' => 'yes',
      'current_e_risk_details' => 'Current E risk present',
      'escape_list' => 'yes',
      'escape_list_details' => 'Escaped 2 times',
      'other_escape_risk_info' => 'yes',
      'other_escape_risk_info_details' => 'Used a small hammer',
      'category_a' => 'yes',
      'category_a_details' => 'Category A present',
      'restricted_status' => 'yes',
      'restricted_status_details' => 'Restricted status present',
      'escape_pack' => '1',
      'escape_risk_assessment' => '1',
      'cuffing_protocol' => '1'
    }
  }

  describe 'defaults' do
    its(:current_e_risk) { is_expected.to eq 'unknown' }
    its(:escape_list) { is_expected.to eq 'unknown' }
    its(:other_escape_risk_info) { is_expected.to eq 'unknown' }
    its(:category_a) { is_expected.to eq 'unknown' }
    its(:restricted_status) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ current_e_risk_details
          escape_list_details
          other_escape_risk_info_details
          category_a_details
          restricted_status_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it 'coerces params' do
      subject.validate(params)
      coerced_params = params.merge('escape_pack' => true, 'escape_risk_assessment' => true, 'cuffing_protocol' => true)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it do
      is_expected.
        to validate_inclusion_of(:current_e_risk).
        in_array(%w[ yes no unknown ])
    end

    context 'when current_e_risk is set to yes' do
      before { subject.current_e_risk = 'yes' }
      it { is_expected.to validate_presence_of(:current_e_risk_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:escape_list).
        in_array(%w[ yes no unknown ])
    end

    context 'when escape_list is set to yes' do
      before { subject.escape_list = 'yes' }
      it { is_expected.to validate_presence_of(:escape_list_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:other_escape_risk_info).
        in_array(%w[ yes no unknown ])
    end

    context 'when other_escape_risk_info is set to yes' do
      before { subject.other_escape_risk_info = 'yes' }
      it { is_expected.to validate_presence_of(:other_escape_risk_info_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:category_a).
        in_array(%w[ yes no unknown ])
    end

    context 'when category_a is set to yes' do
      before { subject.category_a = 'yes' }
      it { is_expected.to validate_presence_of(:category_a_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:restricted_status).
        in_array(%w[ yes no unknown ])
    end

    context 'when restricted_status is set to yes' do
      before { subject.restricted_status = 'yes' }
      it { is_expected.to validate_presence_of(:restricted_status_details) }
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
