require 'rails_helper'

RSpec.describe Forms::Risks::SexOffences, type: :form do
  let(:model) { Risks.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      sex_offence: 'yes',
      sex_offence_victim: 'under_18',
      sex_offence_details: 'Age 17',
    }.with_indifferent_access
  }

  describe 'defaults' do
    its(:sex_offence) { is_expected.to eq 'unknown' }
  end

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ sex_offence_details ].each do |attribute|
        it { is_expected.to nilify_empty_strings_for(attribute) }
      end
    end

    it do
      is_expected.
        to validate_inclusion_of(:sex_offence).
        in_array(%w[ yes no unknown ])
    end

    it do
      is_expected.
        to validate_inclusion_of(:sex_offence_victim).
        in_array(%w[ adult_male adult_female under_18 ])
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
