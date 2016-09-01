require 'rails_helper'

RSpec.describe Considerations::Medications do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    before { subject.properties = context_attrs }

    let(:attrs) do
      {
        option: 'yes',
        collection: [
          {
            description: 'paracetamol',
            administration: '500mg every four hours',
            carrier: 'detainee'
          },
          {
            description: 'lunch',
            administration: 'daily, around midday',
            carrier: 'escort'
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
      let(:context_attrs) do
        {
          option: 'yes',
          collection: [
            { description: 'partially completed medication' }
          ]
        }
      end

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid data that needs resetting" do
      let(:context_attrs) { attrs.merge(option: 'no') }

      it "returns true" do
        expect(subject).to be_valid
      end
    end
  end
end
