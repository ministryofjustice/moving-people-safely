require 'rails_helper'

RSpec.describe Considerations::Harassment do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    let(:attrs) do
      {
        option: 'no',
        hostage_taker: false,
        hostage_taker_details: '',
        stalker: false,
        stalker_details: '',
        harasser: false,
        harasser_details: '',
        intimidator: false,
        intimidator_details: '',
        bully: false,
        bully_details: ''
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
      let(:context_attrs) { attrs.merge(option: 'yes', bully: true) }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid data that needs resetting" do
      let(:context_attrs) { attrs.merge(intimidator: true, bully_details: '123') }

      it "returns true" do
        expect(subject).to be_valid
      end
    end
  end
end
