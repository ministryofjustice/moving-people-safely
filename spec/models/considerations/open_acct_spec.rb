require 'rails_helper'

RSpec.describe Considerations::OpenAcct do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    let(:attrs) do
      {
        option: 'no',
      }
    end

    before { subject.properties = context_attrs }

    context "with valid data" do
      let(:context_attrs) { attrs }

      it "returns true" do
        expect(subject).to be_valid
      end
    end

    context "with invalid data" do
      let(:context_attrs) { attrs.merge(option: 'clowns') }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end
  end
end
