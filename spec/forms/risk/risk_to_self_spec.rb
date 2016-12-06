require 'rails_helper'

RSpec.describe Forms::Risk::RiskToSelf, type: :form do
  let(:model) { Risk.new }
  subject(:form) { described_class.new(model) }

  let(:params) {
    { acct_status: 'open' }.with_indifferent_access
  }

  describe '#validate' do
    context 'when ACCT status requires additional details' do
      let(:params) {
        {
          acct_status: 'closed_in_last_6_months',
          acct_status_details: 'some aditional details',
          date_of_most_recently_closed_acct: '10/06/1956'
        }.with_indifferent_access
      }

      specify { expect(form.validate(params)).to be_truthy }

      context 'and they are not provided' do
        let(:missing_attrs) {
          %i[acct_status_details date_of_most_recently_closed_acct]
        }

        it 'fails to validate' do
          expect(form.validate(params.except(*missing_attrs))).to be_falsey
          expect(form.errors.keys).to match_array(missing_attrs)
        end
      end

      context 'when date of most recently closed ACCT is invalid' do
        let(:attr_with_error) { :date_of_most_recently_closed_acct }
        let(:error_message) { 'is not a valid date' }

        it 'an invalid date error is added to the error list' do
          expect(form.validate(params.merge(attr_with_error => 'not-a-date'))).to be_falsey
          expect(form.errors.keys).to match_array([attr_with_error])
          expect(form.errors[attr_with_error]).to match_array([error_message])
        end
      end

      context 'when date of most recently closed ACCT is in the future' do
        let(:attr_with_error) { :date_of_most_recently_closed_acct }
        let(:error_message) { 'is in the future' }

        it 'a date in the future error is added to the error list' do
          expect(form.validate(params.merge(attr_with_error => Date.tomorrow))).to be_falsey
          expect(form.errors.keys).to match_array([attr_with_error])
          expect(form.errors[attr_with_error]).to match_array([error_message])
        end
      end

      context 'when ACCT details is not provided' do
        let(:error_message) { I18n.t(:blank, scope: 'errors.messages') }

        it 'a cannot be blank error is added to the error list' do
          expect(form.validate(params.except(:acct_status_details))).to be_falsey
          expect(form.errors.keys).to match_array(%i[acct_status_details])
          expect(form.errors[:acct_status_details]).to match_array([error_message])
        end
      end
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
