require 'rails_helper'

RSpec.describe Print::OffencesPresenter do
  subject(:presenter) { described_class.new(detainee) }

  describe '#current_offences_label' do
    context 'when there are no current offences' do
      let(:detainee) { FactoryGirl.build(:detainee, :with_no_current_offences) }

      it 'returns a non-highlighed label' do
        expect(presenter.current_offences_label).to eq('Current offences')
      end
    end

    context 'when there are current offences' do
      let(:current_offences) { build_list(:current_offence, 2) }
      let(:detainee) { FactoryGirl.build(:detainee, current_offences: current_offences) }

      it 'returns an highlighed label' do
        expect(presenter.current_offences_label).to eq('<div class="strong-text">Current offences</div>')
      end
    end
  end

  describe '#current_offences_relevant' do
    context 'when there are no current offences' do
      let(:detainee) { FactoryGirl.build(:detainee, :with_no_current_offences) }

      it 'returns a non-highlighed None' do
        expect(presenter.current_offences_relevant).to eq('None')
      end
    end

    context 'when there are current offences' do
      let(:current_offences) { build_list(:current_offence, 2) }
      let(:detainee) { FactoryGirl.build(:detainee, current_offences: current_offences) }

      it 'returns an highlighed Yes' do
        expect(presenter.current_offences_relevant).to eq('<div class="strong-text">Yes</div>')
      end
    end
  end

  describe '#current_offences' do
    context 'when there are no current offences' do
      let(:detainee) { FactoryGirl.build(:detainee, :with_no_current_offences) }

      it 'returns nil' do
        expect(presenter.current_offences).to be_nil
      end
    end

    context 'when there are current offences' do
      let(:current_offences) { build_list(:current_offence, 2) }
      let(:detainee) { FactoryGirl.build(:detainee, current_offences: current_offences) }

      it 'returns the list of current offences' do
        current_offences.each do |offence|
          expect(presenter.current_offences).to include(%[#{offence.offence} (#{offence.case_reference})])
        end
      end
    end
  end
end
