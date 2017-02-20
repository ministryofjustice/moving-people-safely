require 'rails_helper'

RSpec.describe Print::DetaineePresenter, type: :presenter do
  let(:options) { {} }
  let(:detainee) { FactoryGirl.create(:detainee, options) }

  subject(:presenter) { described_class.new(detainee) }

  describe '#identifier' do
    let(:options) { { prison_number: 'A1401AE', surname: 'Doe' } }
    specify { expect(presenter.identifier).to eq('A1401AE: Doe') }
  end

  describe 'cro_number' do
    context 'when the CRO number is not present' do
      let(:options) { { cro_number: nil } }
      specify { expect(presenter.cro_number).to eq('None') }
    end

    context 'when the CRO number is present' do
      let(:options) { { cro_number: '123456' } }
      specify { expect(presenter.cro_number).to eq('123456') }
    end
  end

  describe 'pnc_number' do
    context 'when the PNC number is not present' do
      let(:options) { { pnc_number: nil } }
      specify { expect(presenter.pnc_number).to eq('None') }
    end

    context 'when the PNC number is present' do
      let(:options) { { pnc_number: '123456' } }
      specify { expect(presenter.pnc_number).to eq('123456') }
    end
  end

  describe '#nationalities' do
    context 'when the detainee info has no nationalities' do
      let(:options) { { nationalities: '' } }
      specify {
        expect(presenter.nationalities).to match_array(%w[None])
      }
    end

    context 'when the detainee info has nationalities' do
      let(:options) { { nationalities: 'British, American' } }
      specify {
        expect(presenter.nationalities).to match_array(%w[British American])
      }
    end
  end

  describe '#aliases' do
    context 'when the detainee info has no aliases' do
      let(:options) { { aliases: '' } }
      specify {
        expect(presenter.aliases).to match_array(%w[None])
      }
    end

    context 'when the detainee info has aliases' do
      let(:options) { { aliases: 'John C. Reily, John C.' } }
      specify {
        expect(presenter.aliases).to match_array(['John C. Reily', 'John C.'])
      }
    end
  end

  describe 'date_of_birth' do
    let(:options) { { date_of_birth: '11/02/1978' } }
    it 'returns the date of birth in the format dd MonthAbr YYYY' do
      expect(presenter.date_of_birth).to eq('11 Feb 1978')
    end
  end

  describe 'gender_code' do
    context 'when the prisoners gender is male' do
      let(:options) { { gender: 'male' } }
      specify { expect(presenter.gender_code).to eq('M') }
    end

    context 'when the prisoners gender is female' do
      let(:options) { { gender: 'female' } }
      specify { expect(presenter.gender_code).to eq('F') }
    end
  end
end
