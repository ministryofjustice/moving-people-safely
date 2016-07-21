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

  describe '#validate' do
    it { is_expected.to validate_optional_details_field(:physical_issues) }
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
