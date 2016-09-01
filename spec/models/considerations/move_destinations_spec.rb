require 'rails_helper'

RSpec.describe Considerations::MoveDestinations do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    before { subject.properties = context_attrs }

    let(:attrs) do
      {
        has_destinations: 'yes',
        destinations: [
          {
            establishment: 'prison',
            must_return: 'must_not_return',
            reasons: 'for a reason'
          }
        ]
      }
    end

    context "with valid parameters" do
      let(:context_attrs) { attrs }

      it "returns true" do
        expect(subject).to be_valid
      end
    end

    context "with invalid parameters" do
      let(:context_attrs) { attrs.merge(destinations: [{establishment: ''}]) }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid parameters that are reset" do
      let(:context_attrs) { attrs.merge(has_destinations: 'no') }

      it "returns false" do
        expect(subject).to be_valid
      end
    end
  end
end
