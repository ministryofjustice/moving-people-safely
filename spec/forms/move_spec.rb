require 'rails_helper'

RSpec.describe Forms::Move, type: :form do
  describe '.form_for' do
    subject { described_class.form_for(user, move) }

    let(:user) { double('User', police?: police) }
    let(:move) { double('Move').as_null_object }

    context 'police user' do
      let(:police) { true }

      it 'returns police version of form' do
        expect(subject.class).to eq(Forms::Police::Move)
      end
    end

    context 'non-police user' do
      let(:police) { false }

      it 'returns prison version of form' do
        expect(subject.class).to eq(Forms::Prison::Move)
      end
    end
  end
end
