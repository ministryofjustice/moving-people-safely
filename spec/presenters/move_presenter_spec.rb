require 'rails_helper'

RSpec.describe MovePresenter, type: :presenter do
  let(:move) { create :move }
  subject { described_class.new move }

  describe '#humanized_date' do
    let(:move) { build :move, date: Date.civil(2017, 6, 14) }
    its(:humanized_date) { is_expected.to eq '14 Jun 2017' }
  end

  describe '#must_return_to' do
    before do
      move.destinations.create(establishment: 'hospital', must_return: 'must_return')
      move.destinations.create(establishment: 'court', must_return: 'must_return')
    end

    it 'returns comma separated string of establishments where the detainee must return to' do
      expect(subject.must_return_to).to eq 'hospital, court'
    end
  end

  describe '#must_not_return_to' do
    before do
      move.destinations.create(establishment: 'hospital', must_return: 'must_not_return')
      move.destinations.create(establishment: 'court', must_return: 'must_not_return')
    end

    it 'returns comma separated string of establishments where the detainee must not return to' do
      expect(subject.must_not_return_to).to eq 'hospital, court'
    end
  end
end
