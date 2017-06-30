require "rails_helper"

RSpec.describe Forms::Base, "resetting attributes" do
  let(:form) do
    Class.new(described_class) do
      property :foo, type: Forms::Base::StrictString, validates: { presence: true }
      property :bar, type: Forms::Base::StrictString

      reset attributes: %i[ bar ], if_falsey: :foo, enabled_value: "yes"

      def self.name; "LOL"; end # form base will keel over and die without it

      def default_attribute_values
        { foo: nil, bar: "default" }
      end
    end
  end

  let(:mock_model) { double("MockModel", foo: nil, bar: nil) }

  subject { form.new(mock_model) }

  let(:quote) { "i like cats" }

  describe "#validate" do
    context "when the form is valid" do
      context "when the 'if_falsey' attribute is not the expected enabled value" do
        let(:unexpected_enabled_value) { "no" }

        it "resets the attributes when" do
          params = { foo: unexpected_enabled_value, bar: quote }
          subject.validate(params)

          expect(subject).to be_valid
          expect(subject.foo).to eq unexpected_enabled_value

          default_field_value_on_reset = "default"
          expect(subject.bar).to eq default_field_value_on_reset
        end
      end

      context "when the 'if_falsey' attribute is the expected enabled value" do
        let(:expected_enabled_value) { "yes" }

        it "retains the attributes even is marked for reset" do
          params = { foo: expected_enabled_value, bar: quote }
          subject.validate(params)

          expect(subject).to be_valid
          expect(subject.bar).to eq quote
          expect(subject.foo).to eq expected_enabled_value
        end
      end
    end

    context "when the form is invalid" do
      let(:must_be_present) { nil }

      it "doesn't reset the attributes" do
        params = { foo: must_be_present, bar: quote }
        subject.validate(params)

        expect(subject).not_to be_valid
        expect(subject.bar).to eq quote
        expect(subject.foo).to eq must_be_present
      end
    end
  end
end
