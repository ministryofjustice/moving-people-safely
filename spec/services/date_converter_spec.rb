require 'rails_helper'

RSpec.describe DateConverter, type: :service do
  let(:date_instance) { Date.civil(1999, 12, 31) }

  describe '.convert' do
    context 'with a string in the format DD/MM/YYYY' do
      it 'returns a date instance' do
        expect(described_class.convert('31/12/1999')).to eq date_instance
      end
    end

    context 'with a string not in a date format' do
      it 'returns the string' do
        expect(described_class.convert('12/2016')).to eq '12/2016'
      end
    end

    context 'with nil' do
      it 'returns nil' do
        expect(described_class.convert(nil)).to be_nil
      end
    end

    context 'with a date instance' do
      it 'returns the date' do
        expect(described_class.convert(date_instance)).to eq date_instance
      end
    end
  end
end
