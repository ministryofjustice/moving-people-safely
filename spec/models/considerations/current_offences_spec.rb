require 'rails_helper'

RSpec.describe Considerations::CurrentOffences do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    let(:result) { subject.valid? }
    before { subject.offences = form_data }

    context "with valid parameters" do
      let(:form_data) do
        [
          {
            'offence': '123',
            'case_reference': '123'
          },
          {
            'offence': '456',
            'case_reference': '456'
          }
        ]
      end

      it "returns true" do
        expect(result).to be true
      end
    end

    context "with invalid parameters" do
      let(:form_data) { { blah: 'blah' } }

      it "returns false" do
        expect(result).to be false
      end
    end
  end
end
