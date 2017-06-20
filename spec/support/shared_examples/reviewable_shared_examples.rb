require 'spec_helper'

RSpec.shared_examples_for 'reviewable' do
  it { is_expected.to belong_to(:reviewer) }

  let(:user) { create(:user) }

  describe "#confirm!" do
    before { subject.confirm!(user: user) }

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

  describe '#reviewed?' do
    context 'when has been reviewed' do
      subject { described_class.new(reviewer: user, reviewed_at: 1.day.ago)}
      specify { expect(subject.reviewed?).to be_truthy }
    end

    context 'when has not been reviewed' do
      specify { expect(subject.reviewed?).to be_falsey }
    end
  end
end
