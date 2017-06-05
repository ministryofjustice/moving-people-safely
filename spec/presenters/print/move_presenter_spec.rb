require 'rails_helper'

RSpec.describe Print::MovePresenter, type: :presenter do
  let(:options) { {} }
  let(:move) { create(:move, options) }

  subject(:presenter) { described_class.new(move) }

  describe '#date' do
    let(:date) { 3.days.from_now }
    let(:options) { { date: date } }

    it 'returns the humanized version of the date' do
      expect(presenter.date).to eq(date.strftime('%d %b %Y'))
    end
  end
end
