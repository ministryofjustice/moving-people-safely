require 'rails_helper'

RSpec.describe Escort, type: :model do
  describe ".create_with_children" do
    let(:result) { described_class.create_with_children(prison_number: prison_number) }
    let(:prison_number) { 'pxn' }

    it "creates a detainee with the prison_number" do
      detainee = result.detainee
      expect(detainee).to be_a Detainee
      expect(detainee.prison_number).to eql prison_number
      result.destroy
      expect(detainee).to be_destroyed
    end

    it "creates an associated move record" do
      move = result.move
      expect(move).to be_a Move
      result.destroy
      expect(move).to be_destroyed
    end

    it "creates an associated healthcare record" do
      healthcare = result.healthcare
      expect(healthcare).to be_a Healthcare
      result.destroy
      expect(healthcare).to be_destroyed
    end

    it "creates an associated offences record" do
      offences = result.offences
      expect(offences).to be_a Offences
      result.destroy
      expect(offences).to be_destroyed
    end

    it "creates an associated risk record" do
      risk = result.risk
      expect(risk).to be_a Risk
      result.destroy
      expect(risk).to be_destroyed
    end
  end

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

  describe '#with_future_move?' do
    context 'when there is a future move' do
      subject { build :escort, :with_future_move }
      its(:with_future_move?) { is_expected.to be true }
    end

    context 'when there is not a future move' do
      subject { build :escort, :with_past_move }
      its(:with_future_move?) { is_expected.to be_blank }
    end
  end

  describe '#with_past_move?' do
    context 'when there is a past move' do
      subject { build :escort, :with_past_move }
      its(:with_past_move?) { is_expected.to be true }
    end

    context 'when there is a future move' do
      subject { build :escort, :with_future_move }
      its(:with_past_move?) { is_expected.to be_blank }
    end
  end

  describe '#with_move?' do
    context 'when there is a past move' do
      subject { build :escort, :with_past_move }
      its(:with_move?) { is_expected.to be true }
    end

    context 'when there is a future move' do
      subject { build :escort }
      its(:with_move?) { is_expected.to be true }
    end
  end
end
