require 'rails_helper'

RSpec.describe Workflow do
  subject { described_class.new(type: 'move') }

  describe "#confirm_with_user!" do
    before { subject.confirm_with_user!(user: user) }
    let(:user) { create(:user) }

    it "sets the reviewed_by attribute" do
      expect(subject.reviewer).to eql user
    end

    it "sets the reviewed_at attribute" do
      expect(subject.reviewed_at).not_to be nil
    end

    it "sets the status attribute to :confirmed" do
      expect(subject.confirmed?).to be true
    end
  end
end
