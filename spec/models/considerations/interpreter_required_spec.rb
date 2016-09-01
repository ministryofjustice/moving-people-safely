require 'rails_helper'

RSpec.describe Considerations::InterpreterRequired do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    before { subject.properties = context_attrs }
    let(:attrs) do
      {
        'option': 'no',
        'language': ''
      }
    end

    context "with valid parameters" do
      let(:context_attrs) { attrs }

      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "with invalid parameters" do
      let(:context_attrs) { attrs.merge(option: 'yes') }

      it "is invalid" do
        expect(subject).to_not be_valid
      end
    end

    context "with invalid parameters that require resetting" do
      let(:context_attrs) { attrs.merge(language: 'french') }

      it "is valid" do
        expect(subject).to be_valid
      end
    end
  end
end
