require 'rails_helper'

RSpec.describe DatePicker do
  subject { described_class.new(date) }

  context "initialized with a valid date string" do
    let(:date) { '15/09/2027' }

    describe "#date" do
      let(:result) { subject.date }

      it "returns a date object" do
        expect(result).to be_a Date
      end

      it "returns the correct date" do
        expect(result).to eql Date.strptime(date, '%d/%m/%Y')
      end
    end

    describe "#to_s" do
      let(:result) { subject.to_s }

      it "returns the initializing date as correctly formatted string" do
        expect(result).to eq date
      end
    end

    describe "#date=" do
      before { subject.date = new_date }

      context "with a valid date string" do
        let(:new_date) { '01/01/2001' }

        it "sets the date" do
          expect(subject.date).to eql Date.new(2001, 1, 1)
        end

        it "sets the date string" do
          expect(subject.to_s).to eql new_date
        end
      end

      context "with an invalid date string" do
        let(:new_date) { 'elephant' }

        it "doesn't change the #date" do
          expect(subject.date).to eql Date.new(2027, 9, 15)
        end

        it "doesn't change the date returned by #to_s" do
          expect(subject.to_s).to eql date
        end
      end
    end

    context "date modifiers" do
      let(:result) { subject.date }

      describe "#forward" do
        before { subject.forward }

        it "increments the date by one day" do
          expect(result).to eql (Date.strptime(date, '%d/%m/%Y') + 1.day)
        end
      end

      describe "#back" do
        before { subject.back }

        it "decrements the date by one day" do
          expect(result).to eql (Date.strptime(date, '%d/%m/%Y') - 1.day)
        end
      end

      describe "#today" do
        before { subject.today }

        it "sets the date to today's date" do
          expect(result).to eql Date.today
        end
      end
    end
  end

  context "initialized with an invalid date string" do
    let(:date) { '01/13/2016' }

    describe "#date" do
      let(:result) { subject.date }

      it "returns today's date" do
        expect(result).to eql Date.today
      end
    end

    describe "#to_s" do
      let(:result) { subject.to_s }

      it "returns the initializing string" do
        expect(result).to eq date
      end
    end

    describe "#forward" do
      before { subject.forward }

      it "#date returns tomorrows date" do
        expect(subject.date).to eql Date.tomorrow
      end

      it "#to_s returns tomorrows date" do
        expect(subject.to_s).to eql Date.tomorrow.strftime('%d/%m/%Y')
      end
    end
  end
end
