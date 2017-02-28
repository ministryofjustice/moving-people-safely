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

  describe '#must_return_to_label' do
    context 'when the move has no destinations the detainee must return to' do
      let(:options) { { destinations: [] } }

      it 'returns a non-hightlighted version of the label' do
        expect(presenter.must_return_to_label).to eq('<div class="title">Must return to</div>')
      end
    end

    context 'when the move has destinations the detainee must return to' do
      let(:must_return_to_destinations) { build_list(:destination, 2, :must_return) }
      let(:options) { { destinations: must_return_to_destinations } }

      it 'returns an hightlighted version of the label' do
        expect(presenter.must_return_to_label).to eq('<div class="strong-text">Must return to</div>')
      end
    end
  end

  describe '#must_not_return_to_label' do
    context 'when the move has no destinations the detainee must return to' do
      let(:options) { { destinations: [] } }

      it 'returns a non-hightlighted version of the label' do
        expect(presenter.must_not_return_to_label).to eq('<div class="title">Must NOT return to</div>')
      end
    end

    context 'when the move has destinations the detainee must return to' do
      let(:must_not_return_to_destinations) { build_list(:destination, 2, :must_not_return) }
      let(:options) { { destinations: must_not_return_to_destinations } }

      it 'returns an hightlighted version of the label' do
        expect(presenter.must_not_return_to_label).to eq('<div class="strong-text">Must NOT return to</div>')
      end
    end
  end

  describe '#must_return_to' do
    context 'when the move has no destinations the detainee must return to' do
      let(:options) { { destinations: [] } }

      it 'returns None' do
        expect(presenter.must_return_to).to eq('None')
      end
    end

    context 'when the move has destinations the detainee must return to' do
      let(:must_return_to_destinations) { build_list(:destination, 2, :must_return) }
      let(:options) { { destinations: must_return_to_destinations } }

      it 'returns the list of destinations' do
        must_return_to_destinations.each do |destination|
          expect(presenter.must_return_to).to include(%[<div class="strong-text">#{destination.establishment}: #{destination.reasons}</div>])
        end
      end
    end
  end

  describe '#must_not_return_to' do
    context 'when the move has no destinations the detainee must return to' do
      let(:options) { { destinations: [] } }

      it 'returns None' do
        expect(presenter.must_not_return_to).to eq('None')
      end
    end

    context 'when the move has destinations the detainee must return to' do
      let(:must_not_return_to_destinations) { build_list(:destination, 2, :must_not_return) }
      let(:options) { { destinations: must_not_return_to_destinations } }

      it 'returns the list of destinations' do
        must_not_return_to_destinations.each do |destination|
          expect(presenter.must_not_return_to).to include(%[<div class="strong-text">#{destination.establishment}: #{destination.reasons}</div>])
        end
      end
    end
  end
end
