require 'rails_helper'

RSpec.describe Considerations::Violence do
  subject { described_class.build(name: 'test') }

  describe "#valid?" do
    let(:attrs) do
      {
        option: 'no',
        prison_staff: false,
        prison_staff_details: '',
        risk_to_females: false,
        risk_to_females_details: '',
        escort_or_court_staff: false,
        escort_or_court_staff_details: '',
        healthcare_staff: false,
        healthcare_staff_details: '',
        other_detainees: false,
        other_detainees_details: '',
        homophobic: false,
        homophobic_details: '',
        racist: false,
        racist_details: '',
        public_offence_related: false,
        public_offence_related_details: '',
        police: false,
        police_details: ''
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
      let(:context_attrs) { attrs.merge(option: 'yes', prison_staff: true) }

      it "returns false" do
        expect(subject).not_to be_valid
      end
    end

    context "with invalid data that needs resetting" do
      let(:context_attrs) { attrs.merge(prison_staff: true, prison_staff_details: '123') }

      it "returns true" do
        expect(subject).to be_valid
      end
    end
  end
end
