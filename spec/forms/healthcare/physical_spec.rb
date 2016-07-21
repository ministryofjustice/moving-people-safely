require 'rails_helper'

RSpec.describe Forms::Healthcare::Physical, type: :form do
  let(:model) { Healthcare.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      physical_issues: 'yes',
      physical_issues_details: 'Problems with the heart',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:physical_issues) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    it do
      is_expected.
        to validate_inclusion_of(:physical_issues).
        in_array(%w[ yes no unknown ])
    end

    context 'when physical_issues is set to yes' do
      before { subject.physical_issues = 'yes' }
      it { is_expected.to validate_presence_of(:physical_issues_details) }
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
