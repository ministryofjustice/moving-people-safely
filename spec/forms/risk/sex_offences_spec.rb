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
    describe "sex_offence" do
      it { is_expected.to validate_optional_field(:sex_offence) }
    end

    it {
      is_expected.to validate_attributes_are_reset(:sex_offence_details).
        when_attribute_is_disabled(:sex_offence)
    }

    it {
      is_expected.to validate_attributes_are_reset(:sex_offence_victim).
        when_attribute_is_disabled(:sex_offence).with_attribute_value_set_as('adult_male')
    }

    describe "sex_offence_details" do
      it { is_expected.to validate_strict_string(:sex_offence_details) }

      context 'when sex_offence is set to yes' do
        before { subject.sex_offence = 'yes' }

        context "when the victim is set to under 18" do
           before { subject.sex_offence_victim = 'under_18' }
           it { is_expected.to validate_presence_of(:sex_offence_details) }
        end

        %w[ adult_male adult_female ].each do |sex_offence_victim|
          before { subject.sex_offence_victim = sex_offence_victim }
          it { is_expected.not_to validate_presence_of(:sex_offence_details) }
        end
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
