require 'rails_helper'

RSpec.describe Forms::Move, type: :form do
  let(:model) { build(:move, to: nil) }

  subject(:form) { described_class.new(model) }

  let(:params) {
    {
      to_magistrates_court: 'Albany',
      to_type: 'magistrates_court',
      date: '1/2/2017',
      not_for_release: 'yes',
      not_for_release_reason: 'held_for_immigration'
    }.with_indifferent_access
  }

  describe '#validate' do
    describe 'nilifies empty strings' do
      %w[not_for_release_reason not_for_release_reason_details].each do |attribute|
        it { is_expected.to validate_strict_string(attribute) }
      end
    end

    it 'coerces params' do
      coerced_params = params.merge(
        date: Date.civil(2017, 2, 1)
      )

      form.validate(params)
      expect(form.to_nested_hash).to match_array coerced_params
    end

    context "for not for release" do
      it { is_expected.to validate_optional_field(:not_for_release, inclusion: { in: %w(yes no) }) }

      shared_examples_for 'validation error on not for release value' do
        it 'returns an inclusion validation error' do
          expect(form).not_to be_valid
          expect(form.errors.keys).to include(:not_for_release)
          expect(form.errors[:not_for_release]).to match_array(['question must be answered'])
        end
      end

      shared_examples_for 'no validation on not for release reason' do
        it 'does not validate the reason (and details) for release' do
          form.valid?
          expect(form.errors.keys).not_to include(:not_for_release_reason)
          expect(form.errors.keys).not_to include(:not_for_release_reason_details)
        end
      end

      context 'when not for release is set to no' do
        before do
          form.not_for_release = 'no'
          form.not_for_release_reason = nil
          form.not_for_release_reason_details = nil
        end

        include_examples 'no validation on not for release reason'

        context 'and not for release reason is set to other' do
          before do
            form.not_for_release_reason = 'other'
          end

          include_examples 'no validation on not for release reason'
        end
      end

      context 'when not for release is set to yes' do
        before { form.not_for_release = 'yes' }

        shared_examples_for 'invalid not for release reason' do
          it 'an inclusion error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to include(:not_for_release_reason)
            expect(form.errors[:not_for_release_reason]).to match_array(['^Choose a reason why they must not be released'])
          end
        end

        context 'but not reason is supplied' do
          before { form.not_for_release_reason = nil }
          include_examples 'invalid not for release reason'
        end

        context 'but an invalid reason is supplied' do
          before { form.not_for_release_reason = 'not-a-valid-one' }
          include_examples 'invalid not for release reason'
        end

        context 'reason supplied is valid' do
          context 'from prison' do
            before { form.not_for_release_reason = 'serving_sentence' }

            specify {
              form.valid?
              expect(form.errors.keys).not_to include(:not_for_release_reason)
            }
          end

          context 'from police' do
            let(:model) { build(:move, :from_police, to: nil) }

            before { form.not_for_release_reason = 'prison_production' }

            specify {
              form.valid?
              expect(form.errors.keys).not_to include(:not_for_release_reason)
            }
          end
        end

        context 'reason supplied requires extra details' do
          before do
            form.not_for_release_reason = 'other'
            form.not_for_release_reason_details = 'some details'
          end

          context 'and no details are provided' do
            before { form.not_for_release_reason_details = nil }

            it 'a presence error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to include(:not_for_release_reason_details)
              expect(form.errors[:not_for_release_reason_details]).to match_array(['^Please provide details why the detainee is not for release'])
            end
          end

          specify {
            form.valid?
            expect(form.errors.keys).not_to include(:not_for_release_reason_details)
          }
        end
      end
    end

    describe 'reset not for release associated information' do
      it { is_expected.to be_configured_to_reset(%i[not_for_release_reason not_for_release_reason_details]).when(:not_for_release).not_set_to('yes') }
    end

    describe 'reset not for release reason associated details' do
      it { is_expected.to be_configured_to_reset(%i[not_for_release_reason_details]).when(:not_for_release_reason).not_set_to('other') }
    end

    context 'date' do
      context 'with a valid date' do
        it 'returns true' do
          params[:date] = '12/01/2030'
          expect(form.validate(params)).to be true
        end
      end

      context 'with an invalid date' do
        it 'returns false' do
          params[:date] = 'invalid'
          expect(form.validate(params)).to be false
        end

        it 'sets an error on date' do
          params[:date] = 'invalid'
          form.validate(params)
          expect(form.errors).to include :date
        end
      end

      context "with a date in the past" do
        it 'returns false' do
          params[:date] = '01/01/2015'
          expect(form.validate(params)).to be false
        end

        it 'sets a descriptive error on date' do
          params[:date] = '01/01/2015'
          form.validate(params)
          expect(form.errors[:date]).to include '^Enter a date from today onwards'
        end
      end
    end
  end

  describe '#save' do
    it 'sets the data on the model' do
      form.validate(params)
      form.save

      model_attributes = form.to_nested_hash.except(:to_magistrates_court).
        merge(to: form.to_nested_hash[:to_magistrates_court])

      expect(model.attributes).to include(model_attributes)
    end
  end

  describe '#not_for_release_reasons' do
    context 'from prison' do
      it 'has correct list' do
        expect(subject.not_for_release_reasons).to match_array(%w[
          serving_sentence
          further_charges
          licence_revoke
          held_for_immigration
          other
          ])
      end
    end

    context 'from police' do
      let(:model) { build(:move, :from_police, to: nil) }

      it 'has correct list' do
        expect(subject.not_for_release_reasons).to match_array(%w[
          prison_production
          recall_to_prison
          held_for_immigration
          other
          ])
      end
    end
  end
end
