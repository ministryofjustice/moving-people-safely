require 'rails_helper'

RSpec.describe Print::MovePresenter, type: :presenter do
  let(:options) { {} }
  let(:move) { build(:move, options) }

  subject(:presenter) { described_class.new(move) }

  describe '#date' do
    let(:date) { 3.days.from_now }
    let(:options) { { date: date } }

    it 'returns the humanized version of the date' do
      expect(presenter.date).to eq(date.strftime('%d %b %Y'))
    end
  end

  describe '#not_for_release_text' do
    context 'when not_for_release is not yes' do
      context 'when not_for_release_reason is not other' do
        let(:options) { { not_for_release: 'yes', not_for_release_reason: 'held_for_immigration' } }

        it 'returns the humanized version of not_for_release_reason' do
          expect(presenter.not_for_release_text).to eq('Held for immigration')
        end
      end

      context 'when not_for_release_reason is other' do
        let(:options) { { not_for_release: 'yes', not_for_release_reason: 'other', not_for_release_reason_details: 'not specified' } }

        it 'returns the humanized version of not_for_release_reason_details' do
          expect(presenter.not_for_release_text).to eq('Not specified')
        end
      end
    end

    context 'when not_for_release is not no' do
      let(:options) { { not_for_release: 'no' } }

      it 'returns "Contact the prison to confirm release"' do
        expect(presenter.not_for_release_text).to eq('Contact the prison to confirm release')
      end
    end
  end
end
