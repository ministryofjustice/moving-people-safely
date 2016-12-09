require 'rails_helper'

RSpec.describe AccessPolicy do
  subject { described_class }
  let(:move) { FactoryGirl.build(:move, move_workflow: workflow) }
  let(:workflow) { FactoryGirl.build(:move_workflow) }

  describe "#print?" do
    let(:result) { subject.print?(move: move) }

    context "with a completed PER" do
      before { allow(move).to receive(:complete?).and_return(true) }

      it "is true" do
        expect(result).to be true
      end
    end

    context "PER is incomplete" do
      before { allow(move).to receive(:complete?).and_return(false) }

      it "is false" do
        expect(result).to be false
      end
    end
  end

  describe "#edit?" do
    let(:result) { subject.edit?(move: move) }

    context "PER has not been printed" do
      before { allow(workflow).to receive(:active?).and_return(true) }

      it "is true" do
        expect(result).to be true
      end
    end

    context "with a previously printed PER" do
      before { allow(workflow).to receive(:active?).and_return(false) }

      it "is false" do
        expect(result).to be false
      end
    end
  end
end
