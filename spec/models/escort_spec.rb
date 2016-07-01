require 'rails_helper'

RSpec.describe Escort, type: :model do
  it { is_expected.to have_one(:detainee).dependent(:destroy) }
  it { is_expected.to have_one(:move).dependent(:destroy) }
  it { is_expected.to have_one(:healthcare).dependent(:destroy) }

  describe '.find_detainee_by_prison_number' do
    subject { described_class.find_detainee_by_prison_number('A1234BC') }

    context 'when there is an associated matching detainee' do
      it 'returns the escort' do
        escort = Escort.create.tap do |e|
          e.create_detainee(prison_number: 'A1234BC')
        end

        expect(subject).to eq escort
      end
    end

    context 'when there is no associated matching detainee' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#move' do
    context 'when there is no associated record' do
      before { subject.move = nil }
      its(:move) { is_expected.to be_a Move }
    end
  end

  describe '#healthcare' do
    context 'when there is no associated record' do
      before { subject.healthcare = nil }
      its(:healthcare) { is_expected.to be_a Healthcare }
    end
  end

  describe "#offenses" do
    let(:subject) { described_class.new }
    let(:result) { subject.offenses }

    context "when there is no associated record" do
      it "returns an Offenses object" do
        expect(result).to be_an Offenses
      end
    end
  end
end
