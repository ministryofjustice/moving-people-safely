require 'rails_helper'

RSpec.describe OffencesForm, type: :form do
  subject { described_class.new(Offences.new) }

  let(:form_data) do
    {
      'release_date' => release_date,
      'not_for_release' => true,
      'not_for_release_reason' => 'remember what happened last time?'
    }
  end

  let(:release_date) { '15/09/2027' }

  describe "#validate" do
    let(:result) { subject.validate(form_data) }

    it { is_expected.to validate_presence_of(:release_date) }

    context "release_date" do
      context "with a text date in UK format (DD/MM/YYYY)" do
        let(:release_date) { '31/01/2017' }

        it "is valid" do
          expect(result).to be true
        end
      end

      context "with text that cannot be coerced to a date" do
        let(:release_date) { 'this is no format for a date' }

        it "is invalid" do
          expect(result).to be false
        end

        it "sets an error message" do
          expect(subject.errors[:release_date]).to include "sdf"
        end
      end

      context "with missing data" do
        let(:release_date) { nil }

        it "is invalid" do
          expect(result).to be false
        end

        it "sets an error message" do
          expect(subject.errors[:release_date]).to include "cannot be blank"
        end
      end
    end

    context "not_for_release" do
      context "accepts boolean" do

      end
    end
  end
end