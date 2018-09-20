require 'rails_helper'

RSpec.describe CompareAutoAlerts::CsvWriter do
  subject { described_class.write(comparisons) }

  let(:comparisons) do
    {
      'A0000Z' => {
        id: 'abc123',
        moved_at: Date.new(2001,1,1),
        to_type: 'prison',
        days_since_moved: 22,
        comparison: {
          my_attribute: {
            human: 'yes',
            auto: 'yes',
            outcome: 'MATCH'
          },
          my_other_attribute: {
            human: 'no',
            auto: 'no',
            outcome: 'MATCH'
          }
        }
      }
    }
  end

  describe '.write' do
    let(:csv_out) do
      <<-ENDCSV
escort_id,prison_number,moved_at,to_type,attribute,human,auto,outcome,days_since_moved
abc123,A0000Z,01/01/2001,prison,my_attribute,yes,yes,MATCH,22
abc123,A0000Z,01/01/2001,prison,my_other_attribute,no,no,MATCH,22
      ENDCSV
    end

    it 'CSV output with headers' do
      expect(subject).to eq(csv_out)
    end
  end
end
