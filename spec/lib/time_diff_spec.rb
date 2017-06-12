require 'rails_helper'
require 'time_diff'

RSpec.describe TimeDiff do
  subject(:diff) { described_class.new(start_time, end_time) }

  describe '#to_s' do
    context 'when there is no days difference since the start time' do
      let(:start_time) { Time.local(2008, 9, 1, 12, 0, 0) }
      let(:end_time) { Time.local(2008, 9, 1, 14, 25, 46) }

      it 'returns the humanized time difference without days passed' do
        expect(diff.to_s).to eq('2 hours, 25 minutes, 46 seconds')
      end
    end

    context 'when there is no hours difference since the start time' do
      let(:start_time) { Time.local(2008, 9, 1, 12, 0, 0) }
      let(:end_time) { Time.local(2008, 9, 11, 12, 23, 46) }

      it 'returns the humanized time difference without hours passed' do
        expect(diff.to_s).to eq('10 days, 23 minutes, 46 seconds')
      end
    end

    context 'when there is no minutes difference since the start time' do
      let(:start_time) { Time.local(2008, 9, 1, 12, 0, 0) }
      let(:end_time) { Time.local(2008, 9, 21, 14, 0, 46) }

      it 'returns the humanized time difference without minutes passed' do
        expect(diff.to_s).to eq('20 days, 2 hours, 46 seconds')
      end
    end

    context 'when there is no seconds difference since the start time' do
      let(:start_time) { Time.local(2008, 9, 1, 12, 0, 0) }
      let(:end_time) { Time.local(2008, 9, 21, 14, 44, 0) }

      it 'returns the humanized time difference without seconds passed' do
        expect(diff.to_s).to eq('20 days, 2 hours, 44 minutes')
      end
    end
  end
end

