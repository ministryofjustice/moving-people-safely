require 'rails_helper'

RSpec.describe Move, type: :model do
  subject { described_class.new }

  describe "#save_copy" do
    before { subject.save_copy }

    it "creates a not-started workflow" do
      expect(subject.workflow.not_started?).to be true
    end

    it "creates a needs-review workflow for risk" do
      expect(subject.risk_workflow.needs_review?).to be true
    end

    it "creates a needs-review workflow for healthcare" do
      expect(subject.healthcare_workflow.needs_review?).to be true
    end

    it "creates a needs-review workflow for offences" do
      expect(subject.offences_workflow.needs_review?).to be true
    end
  end
end
