require 'rails_helper'

RSpec.describe Considerations::DateField do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    before { subject.properties = attrs  }

    context "with valid data" do
      let(:attrs) {  { date: '1/2/1990' } }

      it "returns true" do
        expect(subject).to be_valid
      end
    end

    context "with invalid data" do
      let(:attrs) {  { date: 'thursday' } }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end
  end
end
