require 'rails_helper'

RSpec.describe OffencesPresenter, type: :presenter do
  let(:offences) { build :offences }
  subject { described_class.new offences }

  describe '#styled_current_offences' do
    it 'shows them with <br>' do
      expected_html = offences.current_offences.map(&:offence).join('<br>')
      expect(subject.styled_current_offences).to eq expected_html
    end
  end

  describe '#styled_past_offences' do
    it 'shows them with <br>' do
      expected_html = offences.past_offences.map(&:offence).join('<br>')
      expect(subject.styled_past_offences).to eq expected_html
    end
  end
end
