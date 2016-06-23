require 'rails_helper'

RSpec.describe Forms::Risks::Security, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      current_e_risk: 'yes',
      current_e_risk_details: 'Current E risk present',
      escape_list: 'yes',
      escape_list_details: 'Escaped 2 times',
      other_escape_risk_info: 'yes',
      other_escape_risk_info_details: 'Used a small hammer',
      category_a: 'yes',
      category_a_details: 'Category A present',
      restricted_status: 'yes',
      restricted_status_details: 'Restricted status present',
      escape_pack: '1',
      escape_risk_assessment: '1',
      cuffing_protocol: '1',
    }.with_indifferent_access
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
      %w[ current_e_risk
          escape_list
          other_escape_risk_info
          category_a
          restricted_status ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it 'coerces params' do
      subject.validate(params)
      coerced_params = params.merge(escape_pack: true, escape_risk_assessment: true, cuffing_protocol: true)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    it do
      is_expected.
        to validate_inclusion_of(:current_e_risk).
        in_array(%w[ yes no unknown ])
    end

    it do
      is_expected.
        to validate_inclusion_of(:escape_list).
        in_array(%w[ yes no unknown ])
    end

    it do
      is_expected.
        to validate_inclusion_of(:other_escape_risk_info).
        in_array(%w[ yes no unknown ])
    end

    it do
      is_expected.
        to validate_inclusion_of(:category_a).
        in_array(%w[ yes no unknown ])
    end

    it do
      is_expected.
        to validate_inclusion_of(:restricted_status).
        in_array(%w[ yes no unknown ])
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
