require 'rails_helper'

RSpec.describe OffencesPresenter, type: :presenter do
  subject { described_class.new offences }
  let(:offences) { Considerations::FormFactory.new(create :detainee).(:offences) }

  describe '#styled_current_offences' do
    let(:result) { subject.styled_current_offences }

    before do
      offences.current_offences.offences = [
        { offence: '1', case_reference: '123' },
        { offence: '2', case_reference: '123' },
        { offence: '3', case_reference: '123' }
      ]
    end

    it 'shows them with <br>' do
      expect(result).to eql "1<br>2<br>3"
    end
  end

  describe '#styled_past_offences' do
    let(:result) { subject.styled_past_offences }

    before do
      offences.past_offences.offences = [
        { offence: '1' },
        { offence: '2' },
        { offence: '3' }
      ]
    end

    it 'shows them with <br>' do
      expect(result).to eql "1<br>2<br>3"
    end
  end
end
