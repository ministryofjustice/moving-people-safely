require 'rails_helper'

RSpec.describe Forms::Healthcare::Needs, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      dependencies: 'yes',
      dependencies_details: 'Drugs',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:dependencies) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ dependencies_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:dependencies).
        in_array(%w[ yes no unknown ])
    end

    context 'when dependencies is set to yes' do
      before { subject.dependencies = 'yes' }
      it { is_expected.to validate_presence_of(:dependencies_details) }
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = subject.model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
