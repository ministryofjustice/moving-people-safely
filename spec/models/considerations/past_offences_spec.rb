require 'rails_helper'

RSpec.describe Considerations::PastOffences do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    before { subject.properties = context_attrs }

    let(:attrs) do
      {
        option: 'yes',
        offences: [
          { offence: 'stole a rabbit' },
          { offence: 'tipped a cow' }
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
      let(:context_attrs) { attrs.merge(offences: [{offence: ''}]) }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid parameters that are reset" do
      let(:context_attrs) { attrs.merge(option: 'no') }

      it "returns true" do
        expect(subject).to be_valid
      end
    end
  end
end
