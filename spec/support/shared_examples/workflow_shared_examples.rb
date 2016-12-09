require 'spec_helper'

RSpec.shared_examples_for 'workflow' do
  describe "#confirm_with_user!" do
    let(:user) { create(:user) }

    before { subject.confirm_with_user!(user: user) }

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
