require 'rails_helper'

RSpec.describe Move, type: :model do
  subject(:move) { described_class.new }

  describe '#issued?' do
    context 'when the move is still in incomplete status' do
      let(:move_workflow) { build(:move_workflow) }
      subject(:move) { build(:move, move_workflow: move_workflow) }
      specify { is_expected.not_to be_issued }
    end

    context 'when the move is in confirmed status' do
      let(:move_workflow) { build(:move_workflow, :confirmed) }
      subject(:move) { build(:move, move_workflow: move_workflow) }
      specify { is_expected.not_to be_issued }
    end

    context 'when the move is in issued status' do
      let(:move_workflow) { build(:move_workflow, :issued) }
      subject(:move) { build(:move, move_workflow: move_workflow) }
      specify { is_expected.to be_issued }
    end
  end
end
