require 'rails_helper'

RSpec.describe Detainee do
  describe "#age" do
    it "uses the AgeCalculator" do
      subject = Detainee.new(date_of_birth: Date.today)
      expect(AgeCalculator).to receive(:age).and_return(:two_hundreds)
      expect(subject.age).to eql :two_hundreds
    end
  end

  describe "#each_alias" do
    context 'when there are no aliases' do
      it "returns empty array" do
        expect(subject.each_alias).to eq([])
      end

      it "doesn't yield the provided block" do
        expect { |b| subject.each_alias(&b) }.not_to yield_with_args
      end
    end

    context 'when there aliases are present' do
      subject { described_class.new(aliases: 'a,b,c') }

      it 'yields each alias into the provided block' do
        expect { |b|
          subject.each_alias(&b)
        }.to yield_successive_args('a', 'b', 'c')
      end
    end
  end
end
