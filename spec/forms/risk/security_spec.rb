require 'rails_helper'

RSpec.describe Forms::Risk::Security, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      'current_e_risk' => 'yes',
      'current_e_risk_details' => 'e_list_standard',
      'previous_escape_attempts' => 'yes',
      'prison_escape_attempt' => '1',
      'prison_escape_attempt_details' => 'prison escape attempt details',
      'court_escape_attempt' => '1',
      'court_escape_attempt_details' => 'court escape attempt details',
      'police_escape_attempt' => '1',
      'police_escape_attempt_details' => 'police escape attempt details',
      'other_type_escape_attempt' => '1',
      'other_type_escape_attempt_details' => 'other type escape attempt details',
      'category_a' => 'yes',
      'escape_pack' => 'yes',
      'escape_pack_completion_date' => '23/03/2016',
      'escort_risk_assessment' => 'yes',
      'escort_risk_assessment_completion_date' => '10/12/2000'
    }
  }

  describe '#validate' do
    shared_examples_for 'valid form' do
      it 'no error is added to the error list' do
        expect(form).to be_valid
        expect(form.errors.keys).to be_empty
      end
    end

    it { is_expected.to validate_optional_field(:current_e_risk) }
    it { is_expected.to validate_optional_field(:previous_escape_attempts) }
    it { is_expected.to validate_optional_field(:category_a) }
    it { is_expected.to validate_optional_field(:escort_risk_assessment) }
    it { is_expected.to validate_optional_field(:escape_pack) }

    it 'coerces params' do
      form.validate(params)
      coerced_params = params.merge({
        'prison_escape_attempt' => true,
        'court_escape_attempt' => true,
        'police_escape_attempt' => true,
        'other_type_escape_attempt' => true,
        'escape_pack_completion_date' => Date.new(2016, 3, 23),
        'escort_risk_assessment_completion_date' => Date.new(2000, 12, 10)
      })
      expect(form.to_nested_hash).to eq(coerced_params)
    end

    context 'current_e_risk attribute' do
      shared_examples_for 'no current E risks' do
        it do
          is_expected.
            not_to validate_inclusion_of(:current_e_risk_details).
            in_array(%w[e_list_standard e_list_escort e_list_heightened])
        end
      end

      context "when current_e_risk is set to no" do
        before { form.current_e_risk = 'no' }
        include_examples 'no current E risks'
      end

      context "when current_e_risk is set to unknown" do
        before { form.current_e_risk = 'unknown' }
        include_examples 'no current E risks'
      end

      context "when current_e_risk is set to yes" do
        before { form.current_e_risk = 'yes' }
        it do
          is_expected.
            to validate_inclusion_of(:current_e_risk_details).
            in_array(%w[e_list_standard e_list_escort e_list_heightened])
        end
      end
    end

    context 'previous_escape_attempts' do
      it { is_expected.to validate_optional_field(:previous_escape_attempts) }

      it do
        is_expected.to be_configured_to_reset(%i[
          prison_escape_attempt prison_escape_attempt_details
          court_escape_attempt court_escape_attempt_details
          police_escape_attempt police_escape_attempt_details
          other_type_escape_attempt other_type_escape_attempt_details
        ]).when(:previous_escape_attempts).not_set_to('yes')
      end

      it { is_expected.to be_configured_to_reset([:prison_escape_attempt_details]).when(:prison_escape_attempt).not_set_to(true) }
      it { is_expected.to be_configured_to_reset([:court_escape_attempt_details]).when(:court_escape_attempt).not_set_to(true) }
      it { is_expected.to be_configured_to_reset([:police_escape_attempt_details]).when(:police_escape_attempt).not_set_to(true) }
      it { is_expected.to be_configured_to_reset([:other_type_escape_attempt_details]).when(:other_type_escape_attempt).not_set_to(true) }

      context 'when is set to unknown' do
        before { form.previous_escape_attempts = 'unknown' }
        include_examples 'valid form'
      end

      context 'when is set to no' do
        before { form.previous_escape_attempts = 'no' }
        include_examples 'valid form'
      end

      context 'when is set to yes' do
        before { form.previous_escape_attempts = 'yes' }

        context 'and no type of escape attempt is selected' do
          before do
            form.prison_escape_attempt = false
            form.court_escape_attempt = false
            form.police_escape_attempt = false
            form.other_type_escape_attempt = false
          end

          let(:attr_with_error) { :base }
          let(:error_message) { 'At least one option (Prison, Court, Police, Other) needs to be provided' }

          it { is_expected.not_to validate_presence_of(:prison_escape_attempt_details) }
          it { is_expected.not_to validate_presence_of(:court_escape_attempt_details) }
          it { is_expected.not_to validate_presence_of(:police_escape_attempt_details) }
          it { is_expected.not_to validate_presence_of(:other_type_escape_attempt_details) }

          it 'inclusion error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'and prison escape attempt is set to true' do
          before { form.prison_escape_attempt = true }

          it { is_expected.to validate_presence_of(:prison_escape_attempt_details) }
        end

        context 'and court escape attempt is set to true' do
          before { form.court_escape_attempt = true }

          it { is_expected.to validate_presence_of(:court_escape_attempt_details) }
        end

        context 'and police escape attempt is set to true' do
          before { form.police_escape_attempt = true }

          it { is_expected.to validate_presence_of(:police_escape_attempt_details) }
        end

        context 'and other_type escape attempt is set to true' do
          before { form.other_type_escape_attempt = true }

          it { is_expected.to validate_presence_of(:other_type_escape_attempt_details) }
        end
      end
    end

    context 'category_a' do
      it { is_expected.to validate_optional_field(:category_a) }
    end

    context 'escort_risk_assessment' do
      it { is_expected.to validate_optional_field(:escort_risk_assessment) }
      it { is_expected.to be_configured_to_reset([:escort_risk_assessment_completion_date]).when(:escort_risk_assessment).not_set_to('yes') }

      context 'when is set to unknown' do
        before { form.escort_risk_assessment = 'unknown' }
        include_examples 'valid form'
      end

      context 'when is set to no' do
        before { form.escort_risk_assessment = 'no' }
        include_examples 'valid form'
      end

      context 'when is set to yes' do
        before { form.escort_risk_assessment = 'yes' }

        context 'but the completion date is not set' do
          before { form.escort_risk_assessment_completion_date = nil }

          let(:attr_with_error) { :escort_risk_assessment_completion_date }
          let(:error_message) { 'is not a valid date' }

          it 'adds an inclusion error to the form errors' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'but the completion date is not a valid date' do
          before { form.escort_risk_assessment_completion_date = 'not-a-date' }

          let(:attr_with_error) { :escort_risk_assessment_completion_date }
          let(:error_message) { 'is not a valid date' }

          it 'adds an inclusion error to the form errors' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'but the completion date is in the future' do
          before { form.escort_risk_assessment_completion_date = Date.tomorrow }

          let(:attr_with_error) { :escort_risk_assessment_completion_date }
          let(:error_message) { 'is in the future' }

          it 'adds an inclusion error to the form errors' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'and the completion date is valid' do
          before { form.escort_risk_assessment_completion_date = '14/02/2016' }
          include_examples 'valid form'
        end
      end
    end

    context 'escape_pack' do
      it { is_expected.to validate_optional_field(:escape_pack) }
      it { is_expected.to be_configured_to_reset([:escape_pack_completion_date]).when(:escape_pack).not_set_to('yes') }

      context 'when is set to unknown' do
        before { form.escape_pack = 'unknown' }
        include_examples 'valid form'
      end

      context 'when is set to no' do
        before { form.escape_pack = 'no' }
        include_examples 'valid form'
      end

      context 'when is set to yes' do
        before { form.escape_pack = 'yes' }

        context 'but the completion date is not set' do
          before { form.escape_pack_completion_date = nil }

          let(:attr_with_error) { :escape_pack_completion_date }
          let(:error_message) { 'is not a valid date' }

          it 'adds an inclusion error to the form errors' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'but the completion date is not a valid date' do
          before { form.escape_pack_completion_date = 'not-a-date' }

          let(:attr_with_error) { :escape_pack_completion_date }
          let(:error_message) { 'is not a valid date' }

          it 'adds an inclusion error to the form errors' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'but the completion date is in the future' do
          before { form.escape_pack_completion_date = Date.tomorrow }

          let(:attr_with_error) { :escape_pack_completion_date }
          let(:error_message) { 'is in the future' }

          it 'adds an inclusion error to the form errors' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([attr_with_error])
            expect(form.errors[attr_with_error]).to match_array([error_message])
          end
        end

        context 'and the completion date is valid' do
          before { form.escape_pack_completion_date = '14/02/2016' }
          include_examples 'valid form'
        end
      end
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      form.validate(params)
      form.save

      form_attributes = form.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
