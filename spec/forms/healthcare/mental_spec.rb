require 'rails_helper'

RSpec.describe Forms::Healthcare::Mental, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      mental_illness: 'yes',
      mental_illness_details: 'Personality problems',
      phobias: 'yes',
      phobias_details: 'Scared of spiders',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:mental_illness) { is_expected.to eq 'unknown' }
    its(:phobias) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ mental_illness_details phobias_details ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:mental_illness).
        in_array(%w[ yes no unknown ])
    end

    context 'when mental_illness is set to yes' do
      before { subject.mental_illness = 'yes' }
      it { is_expected.to validate_presence_of(:mental_illness_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:phobias).
        in_array(%w[ yes no unknown ])
    end

    context 'when phobias is set to yes' do
      before { subject.phobias = 'yes' }
      it { is_expected.to validate_presence_of(:phobias_details) }
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
