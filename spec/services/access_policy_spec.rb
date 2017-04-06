require 'rails_helper'

RSpec.describe AccessPolicy do
  let(:escort) { build(:escort) }

  describe "#edit?" do
    context "with a PER that has not been issued yet" do
      before { allow(escort).to receive(:issued?).and_return(false) }

      it "returns true" do
        expect(described_class.edit?(escort: escort)).to be_truthy
      end
    end

    context "with a PER that has been issued" do
      before { allow(escort).to receive(:issued?).and_return(true) }

      it "returns false" do
        expect(described_class.edit?(escort: escort)).to be_falsey
      end
    end
  end

  describe "#print?" do
    context "with a completed PER" do
      before { allow(escort).to receive(:completed?).and_return(true) }

      it "returns true" do
        expect(described_class.print?(escort: escort)).to be_truthy
      end
    end

    context "PER is incomplete" do
      before { allow(escort).to receive(:completed?).and_return(false) }

      it "returns false" do
        expect(described_class.print?(escort: escort)).to be_falsey
      end
    end
  end
end
