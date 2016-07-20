require 'rails_helper'

RSpec.describe Move, type: :model do
  it { is_expected.to belong_to(:escort) }
  it { is_expected.to have_many(:destinations).dependent(:destroy) }

  describe ".incomplete_healthcare" do
    let(:result) { described_class.with_incomplete_healthcare }

    context "when there are associated incompleted healthcare records" do
      it "returns all the Moves with the associated incomplete records" do
        FactoryGirl.create :escort
        escort = FactoryGirl.create(:escort, :with_incomplete_healthcare)
        expect(result.to_a).to eql [escort.move]
      end
    end
  end

  describe ".incomplete_risk" do
    let(:result) { described_class.with_incomplete_risk }

    context "when there are associated incompleted risk records" do
      it "returns all the Moves with the associated incomplete records" do
        FactoryGirl.create :escort
        escort = FactoryGirl.create(:escort, :with_incomplete_risk)
        expect(result.to_a).to eql [escort.move]
      end
    end
  end

  describe ".incomplete_offences" do
    let(:result) { described_class.with_incomplete_offences }

    context "when there are associated incompleted offences records" do
      it "returns all the Moves with the associated incomplete records" do
        FactoryGirl.create :escort
        escort = FactoryGirl.create(:escort, :with_incomplete_offences)
        expect(result.to_a).to eql [escort.move]
      end
    end
  end
end
