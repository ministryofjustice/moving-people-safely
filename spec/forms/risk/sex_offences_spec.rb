require 'rails_helper'

RSpec.describe Forms::Risk::SexOffences, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  describe '#validate' do
    describe "sex_offence" do
      it { is_expected.to validate_optional_field(:sex_offence) }
    end

    describe "sex_offence_details" do
      it { is_expected.to validate_strict_string(:sex_offence_details) }

      shared_examples_for 'no sex offences' do
        it do
          is_expected.
            not_to validate_inclusion_of(:sex_offence_victim).
            in_array(%w[ adult_male adult_female under_18 ])
        end
      end

      context "when sex_offence is set to no" do
        before { form.sex_offence = 'no' }
        include_examples 'no sex offences'
      end

      context "when sex_offence is set to unknown" do
        before { form.sex_offence = 'unknown' }
        include_examples 'no sex offences'
      end

      context "when sex_offence is set to yes" do
        before { form.sex_offence = 'yes' }

        it do
          is_expected.
            to validate_inclusion_of(:sex_offence_victim).
            in_array(%w[ adult_male adult_female under_18 ])
        end

        context 'but type of victim is not selected' do
          before { form.sex_offence_victim = nil }

          it 'an inclusion error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([:sex_offence_victim])
            expect(form.errors[:sex_offence_victim]).to match_array(['is not included in the list'])
          end
        end

        context "when the victim is set to under 18" do
           before { form.sex_offence_victim = 'under_18' }
           it { is_expected.to validate_presence_of(:sex_offence_details) }
        end

        %w[ adult_male adult_female ].each do |sex_offence_victim|
          before { form.sex_offence_victim = sex_offence_victim }
          it { is_expected.not_to validate_presence_of(:sex_offence_details) }
        end
      end
    end

    it do
      is_expected.to be_configured_to_reset(%i[ sex_offence_victim sex_offence_details ]).
        when(:sex_offence).not_set_to('yes')
    end

    it do
      is_expected.to be_configured_to_reset(%i[ sex_offence_details ]).
        when(:sex_offence_victim).not_set_to('under_18')
    end
  end

  describe '#save' do
    let(:params) {
      {
        'sex_offence' => 'yes',
        'sex_offence_victim' => 'under_18',
        'sex_offence_details' => '17 years old'
      }
    }

    it 'sets the data on the model' do
      form.validate(params)
      form.save

      form_attributes = form.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
