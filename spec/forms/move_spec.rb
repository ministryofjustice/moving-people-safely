require 'rails_helper'

RSpec.describe Forms::Move, type: :form do
  describe '.form_for' do
    subject { described_class.form_for(move) }

    let(:move) { build(:move, from_establishment: establishment) }

    context 'police escort' do
      let(:establishment) { build(:police_custody) }

      it 'returns police version of form' do
        expect(subject.class).to eq(Forms::Police::Move)
      end
    end

    context 'non-police escort' do
      let(:establishment) { build(:prison) }

      it 'returns prison version of form' do
        expect(subject.class).to eq(Forms::Prison::Move)
      end
    end
  end
end
