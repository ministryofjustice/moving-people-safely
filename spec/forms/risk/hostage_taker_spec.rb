require 'rails_helper'

RSpec.describe Forms::Risk::HostageTaker, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  describe '#validate' do
    context "for hostage taker" do
      context 'when hostage taker is set to yes' do
        before { form.hostage_taker = 'yes' }

        context 'but none of the checkboxes is selected' do
          before do
            form.staff_hostage_taker = false
            form.prisoners_hostage_taker = false
            form.public_hostage_taker = false
          end

          it 'an invalid date error is added to the error list' do
            expect(form).not_to be_valid
            expect(form.errors.keys).to match_array([:base])
            expect(form.errors[:base]).to match_array(['At least one option (Staff, Prisoners, Public) needs to be provided'])
          end
        end

        context 'and staff hostage taker is set to true' do
          before { form.staff_hostage_taker = true }

          context 'but date of most recent incident is not present' do
            before { form.date_most_recent_staff_hostage_taker_incident = nil }

            let(:attr_with_error) { :date_most_recent_staff_hostage_taker_incident }
            let(:error_message) { 'is not a valid date' }

            it 'an invalid date error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end

          context 'but date of most recent incident is invalid' do
            before { form.date_most_recent_staff_hostage_taker_incident = 'not-a-date' }

            let(:attr_with_error) { :date_most_recent_staff_hostage_taker_incident }
            let(:error_message) { 'is not a valid date' }

            it 'an invalid date error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end

          context 'but date of most recent incident is in the future' do
            before { form.date_most_recent_staff_hostage_taker_incident = Date.tomorrow }

            let(:attr_with_error) { :date_most_recent_staff_hostage_taker_incident }
            let(:error_message) { 'is in the future' }

            it 'a date in the future error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end
        end

        context 'and prisoners hostage taker is set to true' do
          before { form.prisoners_hostage_taker = true }

          context 'but date of most recent incident is not present' do
            before { form.date_most_recent_prisoners_hostage_taker_incident = nil }

            let(:attr_with_error) { :date_most_recent_prisoners_hostage_taker_incident }
            let(:error_message) { 'is not a valid date' }

            it 'an invalid date error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end

          context 'but date of most recent incident is invalid' do
            before { form.date_most_recent_prisoners_hostage_taker_incident = 'not-a-date' }

            let(:attr_with_error) { :date_most_recent_prisoners_hostage_taker_incident }
            let(:error_message) { 'is not a valid date' }

            it 'an invalid date error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end

          context 'but date of most recent incident is in the future' do
            before { form.date_most_recent_prisoners_hostage_taker_incident = Date.tomorrow }

            let(:attr_with_error) { :date_most_recent_prisoners_hostage_taker_incident }
            let(:error_message) { 'is in the future' }

            it 'a date in the future error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end
        end

        context 'and public hostage taker is set to true' do
          before { form.public_hostage_taker = true }

          context 'but date of most recent incident is not present' do
            before { form.date_most_recent_public_hostage_taker_incident = nil }

            let(:attr_with_error) { :date_most_recent_public_hostage_taker_incident }
            let(:error_message) { 'is not a valid date' }

            it 'an invalid date error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end

          context 'but date of most recent incident is invalid' do
            before { form.date_most_recent_public_hostage_taker_incident = 'not-a-date' }

            let(:attr_with_error) { :date_most_recent_public_hostage_taker_incident }
            let(:error_message) { 'is not a valid date' }

            it 'an invalid date error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end

          context 'but date of most recent incident is in the future' do
            before { form.date_most_recent_public_hostage_taker_incident = Date.tomorrow }

            let(:attr_with_error) { :date_most_recent_public_hostage_taker_incident }
            let(:error_message) { 'is in the future' }

            it 'a date in the future error is added to the error list' do
              expect(form).not_to be_valid
              expect(form.errors.keys).to match_array([attr_with_error])
              expect(form.errors[attr_with_error]).to match_array([error_message])
            end
          end
        end
      end

      it do
        is_expected.to be_configured_to_reset(%i[
          staff_hostage_taker date_most_recent_staff_hostage_taker_incident
          prisoners_hostage_taker date_most_recent_prisoners_hostage_taker_incident
          public_hostage_taker date_most_recent_public_hostage_taker_incident
        ]).when(:hostage_taker).not_set_to('yes')
      end

      describe 'fields associated with checkboxes' do
        it { is_expected.to be_configured_to_reset([:date_most_recent_staff_hostage_taker_incident]).when(:staff_hostage_taker).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:date_most_recent_prisoners_hostage_taker_incident]).when(:prisoners_hostage_taker).not_set_to(true) }
        it { is_expected.to be_configured_to_reset([:date_most_recent_public_hostage_taker_incident]).when(:public_hostage_taker).not_set_to(true) }
      end
    end
  end

  describe '#save' do
    let(:params) {
      {
        'hostage_taker' => 'yes',
        'staff_hostage_taker' => '1',
        'date_most_recent_staff_hostage_taker_incident' => '20/11/1990',
        'prisoners_hostage_taker' => '1',
        'date_most_recent_prisoners_hostage_taker_incident' => '13/01/2004',
        'public_hostage_taker' => '1',
        'date_most_recent_public_hostage_taker_incident' => '02/03/2010'
      }
    }

    it 'sets the data on the model' do
      subject.validate(params)
      subject.save

      form_attributes = subject.to_nested_hash
      model_attributes = model.attributes

      expect(model_attributes).to include form_attributes
    end
  end
end
