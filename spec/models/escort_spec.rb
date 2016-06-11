require 'rails_helper'

RSpec.describe Escort, type: :model do
  it { is_expected.to have_one(:detainee).dependent(:destroy) }
  it { is_expected.to have_one(:move).dependent(:destroy) }

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
end
