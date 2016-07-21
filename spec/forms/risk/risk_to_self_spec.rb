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

  describe 'defaults' do
    its(:open_acct) { is_expected.to eq 'unknown' }
    its(:suicide) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it do
      is_expected.
        to validate_inclusion_of(:open_acct).
        in_array(%w[ yes no unknown ])
    end

    context 'when open_acct is set to yes' do
      before { subject.open_acct = 'yes' }
      it { is_expected.to validate_presence_of(:open_acct_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:suicide).
        in_array(%w[ yes no unknown ])
    end

    context 'when suicide is set to yes' do
      before { subject.suicide = 'yes' }
      it { is_expected.to validate_presence_of(:suicide_details) }
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
