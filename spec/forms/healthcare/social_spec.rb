require 'rails_helper'

RSpec.describe Forms::Healthcare::Social, type: :form do
  subject { described_class.new(Healthcare.new) }

  let(:params) {
    {
      personal_hygiene: 'yes',
      personal_hygiene_details: 'Dirty guy',
      personal_care: 'yes',
      personal_care_details: 'Not changing clothes',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:personal_hygiene) { is_expected.to eq 'unknown' }
    its(:personal_care) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ personal_hygiene_details personal_care_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:personal_hygiene).
        in_array(%w[ yes no unknown ])
    end

    context 'when personal_hygiene is set to yes' do
      before { subject.personal_hygiene = 'yes' }
      it { is_expected.to validate_presence_of(:personal_hygiene_details) }
    end

    it do
      is_expected.
        to validate_inclusion_of(:personal_care).
        in_array(%w[ yes no unknown ])
    end

    context 'when personal_care is set to yes' do
      before { subject.personal_care = 'yes' }
      it { is_expected.to validate_presence_of(:personal_care_details) }
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
