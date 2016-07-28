require 'rails_helper'

RSpec.describe AccessPolicy do
  subject { described_class }

  describe "#print?" do
    let(:result) { subject.print?(escort: escort) }

    context "with a completed PER" do
      let(:escort) { instance_double(Escort, move: instance_double(Move, complete?: true)) }

      it "is true" do
        expect(result).to be true
      end
    end

    context "PER is incomplete" do
      let(:escort) { instance_double(Escort, move: instance_double(Move, complete?: false)) }

      it "is false" do
        expect(result).to be false
      end
    end
  end

  describe "#edit?" do
    let(:result) { subject.edit?(escort: escort) }

    context "PER has not been printed" do
      let(:escort) { instance_double(Escort, workflow_status: 'complete') }

      it "is true" do
        expect(result).to be true
      end
    end

    context "with a previously printed PER" do
      let(:escort) { instance_double(Escort, workflow_status: 'issued') }

      it "is false" do
        expect(result).to be false
      end
    end
  end

  describe "#clone_escort?" do
    let(:result) { subject.clone_escort?(escort: escort) }

    context "with an old move" do
      let(:escort) { instance_double(Escort, with_future_move?: false, with_move?: true) }

      it "is true" do
        expect(result).to be true
      end
    end

    context "with a future move" do
      let(:escort) { instance_double(Escort, with_future_move?: true, with_move?: true) }

      it "is false" do
        expect(result).to be false
      end
    end
  end
end
