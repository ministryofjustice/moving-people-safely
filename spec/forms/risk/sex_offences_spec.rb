require 'rails_helper'

RSpec.describe Forms::Risk::SexOffences, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  describe '#validate' do
    describe "sex_offence" do
      it { is_expected.to validate_optional_field(:sex_offence) }

      context 'when sex_offence is set to no' do
        before { form.sex_offence = 'no' }

        context 'when under 18 is set to true' do
          before { subject.sex_offence_under18_victim = true }
          specify { expect(form).to be_valid }
        end
      end

      context 'when sex_offence is set to yes' do
        before { form.sex_offence = 'yes' }

        context 'but none of the options is selected' do
          before do
            form.sex_offence_adult_male_victim = false
            form.sex_offence_adult_female_victim = false
            form.sex_offence_under18_victim = false
          end

          it 'an inclusion error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([:base])
            expect(form.errors[:base]).to match_array(['At least one option (Adult male, Adult female, Under 18) needs to be provided'])
          end
        end

        context 'when under 18 is set to true' do
          before { subject.sex_offence_under18_victim = true }
          it { is_expected.to validate_presence_of(:sex_offence_under18_victim_details) }
        end
      end
    end

    it do
      is_expected.to be_configured_to_reset(%i[
        sex_offence_adult_male_victim sex_offence_adult_female_victim
        sex_offence_under18_victim sex_offence_under18_victim_details
      ]).when(:sex_offence).not_set_to('yes')
    end
  end

  describe '#save' do
    let(:params) {
      {
        'sex_offence' => 'yes',
        'sex_offence_adult_male_victim' => '1',
        'sex_offence_adult_female_victim' => '1',
        'sex_offence_under18_victim' => '1',
        'sex_offence_under18_victim_details' => '17 years old'
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
