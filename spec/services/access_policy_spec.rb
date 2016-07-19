require 'rails_helper'

RSpec.describe AccessPolicy do
  subject { described_class }

  describe "#print?" do
    let(:result) { subject.print?(escort: escort) }

    context "with a completed PER" do
      let(:escort) { create(:escort) }

      it "is true" do
        expect(result).to be true
      end
    end

    context "PER is incomplete" do
      let(:escort) { create(:escort, :with_incomplete_risks) }

      it "is false" do
        expect(result).to be false
      end
    end
  end
end
