require 'rails_helper'

RSpec.describe Forms::Risk::RiskToSelf, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      open_acct: 'yes',
      open_acct_details: 'There is an open ACCT',
      suicide: 'yes',
      suicide_details: 'Risk of suicide',
    }.with_indifferent_access
  }

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:open_acct) }
    it { is_expected.to validate_optional_details_field(:suicide) }
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
