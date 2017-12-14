require 'rails_helper'

RSpec.describe Prison do
  describe 'default scope' do
    before { create(:prison, end_date: end_date) }
    let(:today) { Date.today }

    shared_examples 'includes it' do
      it 'includes it' do
        expect(Prison.count).to eq(1)
      end
    end

    shared_examples 'excludes it' do
      it 'excludes it' do
        expect(Prison.count).to eq(0)
      end
    end

    context 'prison with no end_date' do
      let(:end_date) { nil }
      it_behaves_like 'includes it'
    end

    context 'prison with end date equating to today' do
      context 'with Y, M and D' do
        let(:end_date) { (today).strftime('%Y-%m-%d') }
        it_behaves_like 'includes it'
      end

      context 'with Y and M' do
        let(:end_date) { (today).strftime('%Y-%m') }
        it_behaves_like 'includes it'
      end

      context 'with just Y' do
        let(:end_date) { (today).strftime('%Y') }
        it_behaves_like 'includes it'
      end
    end

    context 'prison with future end dates' do
      context 'with Y, M and D' do
        let(:end_date) { (today + 1.day).strftime('%Y-%m-%d') }
        it_behaves_like 'includes it'
      end

      context 'with Y and M' do
        let(:end_date) { (today + 1.month).strftime('%Y-%m') }
        it_behaves_like 'includes it'
      end

      context 'with just Y' do
        let(:end_date) { (today + 1.year).strftime('%Y') }
        it_behaves_like 'includes it'
      end
    end

    context 'prison with end date in the past' do
      context 'with Y, M and D' do
        let(:end_date) { (today - 1.day).strftime('%Y-%m-%d') }
        it_behaves_like 'excludes it'
      end

      context 'with Y and M' do
        let(:end_date) { (today - 1.month).strftime('%Y-%m') }
        it_behaves_like 'excludes it'
      end

      context 'with just Y' do
        let(:end_date) { (today - 1.year).strftime('%Y') }
        it_behaves_like 'excludes it'
      end
    end
  end
end
