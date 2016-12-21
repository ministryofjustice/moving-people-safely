require 'rails_helper'

RSpec.describe Forms::Risk::Security, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      'current_e_risk' => 'yes',
      'current_e_risk_details' => 'e_list_standard',
      'category_a' => 'yes',
      'category_a_details' => 'Category A present',
      'restricted_status' => 'yes',
      'restricted_status_details' => 'Restricted status present',
      'escape_pack' => '1',
      'escape_risk_assessment' => '1',
      'cuffing_protocol' => '1'
    }
  }

  describe '#validate' do
    it { is_expected.to validate_optional_field(:current_e_risk) }
    it { is_expected.to validate_optional_details_field(:category_a) }
    it { is_expected.to validate_optional_details_field(:restricted_status) }

    it 'coerces params' do
      subject.validate(params)
      coerced_params = params.merge('escape_pack' => true, 'escape_risk_assessment' => true, 'cuffing_protocol' => true)
      expect(subject.to_nested_hash).to eq coerced_params
    end

    context 'current_e_risk attribute' do
      shared_examples_for 'no current E risks' do
        it do
          is_expected.
            not_to validate_inclusion_of(:current_e_risk_details).
            in_array(%w[e_list_standard e_list_escort e_list_heightened])
        end
      end

      context "when current_e_risk is set to no" do
        before { form.current_e_risk = 'no' }
        include_examples 'no current E risks'
      end

      context "when current_e_risk is set to unknown" do
        before { form.current_e_risk = 'unknown' }
        include_examples 'no current E risks'
      end

      context "when current_e_risk is set to yes" do
        before { form.current_e_risk = 'yes' }
        it do
          is_expected.
            to validate_inclusion_of(:current_e_risk_details).
            in_array(%w[e_list_standard e_list_escort e_list_heightened])
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
