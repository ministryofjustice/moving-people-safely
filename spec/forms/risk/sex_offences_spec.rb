require 'rails_helper'

RSpec.describe Forms::Risk::SexOffences, type: :form do
  let(:model) { Risk.new }
  subject { described_class.new(model) }

  let(:params) {
    {
      'sex_offence' => 'yes',
      'sex_offence_victim' => 'under_18',
      'sex_offence_details' => '17 years old'
    }
  }

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[ sex_offence_details ].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    context "for the 'sex_offence' attribute" do
      it { is_expected.to validate_optional_field(:sex_offence) }

      context 'when sex_offence is set to yes' do
        before { subject.sex_offence = 'yes' }
        it { is_expected.to validate_presence_of(:sex_offence_details) }
      end
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
