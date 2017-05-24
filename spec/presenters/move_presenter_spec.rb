require 'rails_helper'

RSpec.describe MovePresenter, type: :presenter do
  let(:move) { create(:move) }
  subject { described_class.new(move) }

  describe '#humanized_date' do
    let(:move) { build(:move, date: Date.civil(2017, 6, 14)) }
    its(:humanized_date) { is_expected.to eq '14 Jun 2017' }
  end

  describe '#must_return_to' do
    let(:destinations) {
      [
        { establishment: 'other', must_return: 'must_not_return', reasons: 'some other reason' },
        { establishment: 'hospital', must_return: 'must_return', reasons: 'some reason' },
        { establishment: 'court', must_return: 'must_return', reasons: 'other reason' }
      ]
    }

    before do
      destinations.each { |destination| move.destinations.create(destination) }
    end

    it 'returns establishments the detainee must return to including its details separated by a new line' do
      expect(subject.must_return_to).to eq 'hospital (some reason)<br />court (other reason)'
    end

    context 'when no reason was supplied' do
      let(:destinations) {
        [
          { establishment: 'other', must_return: 'must_not_return', reasons: 'some other reason' },
          { establishment: 'hospital', must_return: 'must_return', reasons: nil },
          { establishment: 'court', must_return: 'must_return', reasons: 'other reason' }
        ]
      }

      it 'does not display any reason content' do
        expect(subject.must_return_to).to eq 'hospital<br />court (other reason)'
      end
    end

    context 'when there is no establishments to return to' do
      let(:destinations) {
        [
          { establishment: 'other', must_return: 'must_not_return', reasons: 'some other reason' }
        ]
      }

      specify { expect(subject.must_return_to).to eq('None') }
    end
  end

  describe '#must_not_return_to' do
    let(:destinations) {
      [
        { establishment: 'other', must_return: 'must_return', reasons: 'some other reason' },
        { establishment: 'hospital', must_return: 'must_not_return', reasons: 'some reason' },
        { establishment: 'court', must_return: 'must_not_return', reasons: 'other reason' }
      ]
    }

    before do
      destinations.each { |destination| move.destinations.create(destination) }
    end

    it 'returns establishments where the detainee must not return to including its details separated by a new line' do
      expect(subject.must_not_return_to).to eq 'hospital (some reason)<br />court (other reason)'
    end

    context 'when no reason was supplied' do
      let(:destinations) {
        [
          { establishment: 'other', must_return: 'must_return', reasons: 'some other reason' },
          { establishment: 'hospital', must_return: 'must_not_return', reasons: nil },
          { establishment: 'court', must_return: 'must_not_return', reasons: 'other reason' }
        ]
      }

      it 'does not display any reason content' do
        expect(subject.must_not_return_to).to eq 'hospital<br />court (other reason)'
      end
    end

    context 'when there is no establishments to not return to' do
      let(:destinations) {
        [
          { establishment: 'other', must_return: 'must_return', reasons: 'some other reason' }
        ]
      }

      specify { expect(subject.must_not_return_to).to eq('None') }
    end
  end
end
