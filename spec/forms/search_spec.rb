require 'rails_helper'

RSpec.describe Forms::Search, type: :form do
  let(:params) { { 'prison_number': 'A1234BC' } }

  describe '#validate' do
    it 'sets the prison number on the form' do
      subject.validate(params)
      expect(subject.prison_number).to eq 'A1234BC'
    end

    it { is_expected.to validate_presence_of(:prison_number) }

    it 'expects it to be in the format \A[a-z]\d{4}[a-z]{2}\z/' do
      is_expected.to allow_value('A1234BC').for(:prison_number)
      is_expected.not_to allow_value('not_a_prison_number').for(:prison_number)
    end
  end

  describe "#prison_number" do
    it "returns an upcased string" do
      subject.prison_number = "a1234bc"
      expect(subject.prison_number).to eq "A1234BC"
    end
  end

  describe '#detainee' do
    context 'when the form is valid' do
      context 'when an detainee exists for a given prison number' do
        it 'returns the escort' do
          detainee = create(:detainee)
          subject.validate(prison_number: detainee.prison_number)
          expect(subject.detainee).to eq detainee
        end
      end

      context 'when no detainee exists for a given prison number' do
        it 'returns nothing' do
          subject.validate(prison_number: 'A1234BC')
          expect(subject.detainee).to be_nil
        end
      end

      context 'when the provided prison name is in a different format than the one recorded for the detainee' do
        it 'still returns the correct detainee by being case insensitive' do
          detainee = FactoryGirl.create(:detainee, prison_number: 'A1234BC')
          subject.validate(prison_number: 'a1234bC')
          expect(subject.detainee).to eq(detainee)
        end
      end
    end

    context 'when the form is invalid' do
      it 'returns nothing' do
        subject.validate(prison_number: 'invalid')
        expect(subject.detainee).to be_nil
      end
    end
  end

  describe 'behaves like an activemodel' do
    # Reform expects the model it is initialized with to
    # behave like an ActiveModel(with Conversion functionality),
    # these methods are then exposed publicly on the form.
    its(:id)         { is_expected.to be_nil }
    its(:persisted?) { is_expected.to be false }
    its(:to_key)     { is_expected.to be_nil }
  end
end
