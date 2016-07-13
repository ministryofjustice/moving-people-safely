require 'rails_helper'

RSpec.describe OffencesPresenter, type: :model do
  let(:offences) { build :offences }
  subject { described_class.new offences }

  describe '#styled_current_offences' do
    it 'shows them with <br>' do
      offences.current_offences.build(offence: 'Armed robbery')
      offences.current_offences.build(offence: 'Arson')
      expect(subject.styled_current_offences).to eq 'Armed robbery<br>Arson'
    end
  end

  describe '#styled_past_offences' do
    it 'shows them with <br>' do
      offences.past_offences.build(offence: 'Armed robbery')
      offences.past_offences.build(offence: 'Arson')
      expect(subject.styled_past_offences).to eq 'Armed robbery<br>Arson'
    end
  end
end
