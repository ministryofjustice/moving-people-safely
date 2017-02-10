require 'rails_helper'

RSpec.describe Move, type: :model do
  subject(:move) { described_class.new }

  describe '#issued?' do
    context 'when the move is still in not started status' do
      let(:move_workflow) { build(:move_workflow, status: :not_started) }
      subject(:move) { build(:move, move_workflow: move_workflow) }
      specify { is_expected.not_to be_issued }
    end

    context 'when the move is still in incomplete status' do
      let(:move_workflow) { build(:move_workflow, :incomplete) }
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

  describe "#save_copy" do
    before { subject.save_copy }

    it "creates a not-started workflow" do
      expect(subject.move_workflow.not_started?).to be true
    end

    it "creates a needs-review workflow for risk" do
      expect(subject.risk_workflow.needs_review?).to be true
    end

    it "creates a needs-review workflow for healthcare" do
      expect(subject.healthcare_workflow.needs_review?).to be true
    end

    it "creates a needs-review workflow for offences" do
      expect(subject.offences_workflow.needs_review?).to be true
    end
  end
end
