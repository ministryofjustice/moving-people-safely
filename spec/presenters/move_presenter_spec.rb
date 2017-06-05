require 'rails_helper'

RSpec.describe MovePresenter, type: :presenter do
  let(:move) { create(:move) }
  subject { described_class.new(move) }

  describe '#humanized_date' do
    let(:move) { build(:move, date: Date.civil(2017, 6, 14)) }
    its(:humanized_date) { is_expected.to eq '14 Jun 2017' }
  end
end
