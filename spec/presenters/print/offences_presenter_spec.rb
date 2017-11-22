require 'rails_helper'

RSpec.describe Print::OffencesPresenter do
  subject(:presenter) { described_class.new(detainee) }

  describe '#label' do
    context 'when there are no offences' do
      let(:detainee) { build(:detainee, :with_no_offences) }

      it 'returns a non-highlighed label' do
        expect(presenter.label).to eq('Current offences')
      end
    end

    context 'when there are offences' do
      let(:offences) { build_list(:offence, 2) }
      let(:detainee) { build(:detainee, offences: offences) }

      it 'returns an highlighed label' do
        expect(presenter.label).to eq('<div class="strong-text">Current offences</div>')
      end
    end
  end

  describe '#relevant' do
    context 'when there are no offences' do
      let(:detainee) { build(:detainee, :with_no_offences) }

      it 'returns a non-highlighed None' do
        expect(presenter.relevant).to eq('None')
      end
    end

    context 'when there are offences' do
      let(:offences) { build_list(:offence, 2) }
      let(:detainee) { build(:detainee, offences: offences) }

      it 'returns an highlighed Yes' do
        expect(presenter.relevant).to eq('<div class="strong-text">Yes</div>')
      end
    end
  end

  describe '#formatted_list' do
    context 'when there are no offences' do
      let(:detainee) { build(:detainee, :with_no_offences) }

      it 'returns nil' do
        expect(presenter.formatted_list).to be_nil
      end
    end

    context 'when there are offences' do
      let(:offences) { build_list(:offence, 2) }
      let(:detainee) { build(:detainee, offences: offences) }

      it 'returns the list of offences' do
        offences.each do |offence|
          expect(presenter.formatted_list).to include(%[#{offence.offence} (#{offence.case_reference})])
        end
      end
    end
  end
end
