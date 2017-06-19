require 'rails_helper'

RSpec.describe Detainee do
  describe "#age" do
    it "uses the AgeCalculator" do
      subject = Detainee.new(date_of_birth: Date.today)
      expect(AgeCalculator).to receive(:age).and_return(:two_hundreds)
      expect(subject.age).to eql :two_hundreds
    end
  end
end
