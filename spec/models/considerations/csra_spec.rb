require 'rails_helper'

RSpec.describe Considerations::Csra do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    let(:attrs) do
      {
        option: 'standard',
        details: '',
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
      let(:context_attrs) { attrs.merge(option: 'high') }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid data that needs resetting" do
      let(:context_attrs) { attrs.merge(details: 'abcedef') }

      it "returns true" do
        expect(subject).to be_valid
      end
    end
  end
end
