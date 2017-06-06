require 'rails_helper'

RSpec.describe Summary::EscortSectionStatusPresenter, type: :presenter do
  let(:status) { 'incomplete' }
  let(:escort) { double(Escort) }
  let(:section) { double(:section, status: status, escort: escort) }
  let(:name) { 'section_name' }
  subject(:presenter) { described_class.new(section, name: name) }

  describe '#title' do
    before do
      localize_key("summary.#{name}.title", 'Localised section title')
      allow(escort).to receive(:issued?).and_return(false)
    end

    context 'when the section is incomplete' do
      let(:status) { 'incomplete' }

      it 'returns the localised title for an incomplete section' do
        expect(presenter.title).to eq('Please complete the missing answers')
      end
    end

    context 'when the section needs review' do
      let(:status) { 'needs_review' }

      it 'returns the localised title for an incomplete section' do
        expect(presenter.title).to eq('Check all answers, then confirm and save')
      end
    end

    context 'when the section is confirmed' do
      let(:status) { 'confirmed' }

      it 'returns the localised title for a complete section' do
        expect(presenter.title).to eq('Check all answers, then confirm and save')
      end
    end

    context 'when the section is neither incomplete, needs review or confirmed' do
      let(:status) { 'some_other_status' }

      it 'returns the default title for the section' do
        expect(presenter.title).to eq('Localised section title')
      end
    end

    context 'when the related escort has been issued' do
      let(:status) { 'confirmed' }

      before do
        expect(escort).to receive(:issued?).and_return(true)
      end

      it 'returns the default title for the section' do
        expect(presenter.title).to eq('Localised section title')
      end
    end
  end

  describe '#label' do
    before do
      localize_key("summary.#{name}.label", 'Localised section label')
    end

    context 'when the section is incomplete' do
      let(:status) { 'incomplete' }

      it 'returns label for an incomplete section' do
        expect(presenter.label).to eq('Incomplete')
      end
    end

    context 'when the section needs review' do
      let(:status) { 'needs_review' }

      it 'returns label for an incomplete section' do
        expect(presenter.label).to eq('Review')
      end
    end

    context 'when the section is confirmed' do
      let(:status) { 'confirmed' }

      it 'returns label for a complete section' do
        expect(presenter.label).to eq('Complete')
      end
    end

    context 'when the section is neither incomplete, needs review or confirmed' do
      let(:status) { 'some_other_status' }

      specify { expect(presenter.label).to be_nil }
    end
  end

  describe '#label_status' do
    context 'when the section is incomplete' do
      let(:status) { 'incomplete' }
      specify { expect(presenter.label_status).to eq('incomplete') }
    end

    context 'when the section needs review' do
      let(:status) { 'needs_review' }
      specify { expect(presenter.label_status).to eq('incomplete') }
    end

    context 'when the section is confirmed' do
      let(:status) { 'confirmed' }
      specify { expect(presenter.label_status).to eq('complete') }
    end

    context 'when the section is neither incomplete, needs review or confirmed' do
      let(:status) { 'some_other_status' }

      specify { expect(presenter.label_status).to be_nil }
    end
  end

  describe '#has_status?' do
    context 'when the section is incomplete' do
      let(:status) { 'incomplete' }
      specify { expect(presenter.has_status?).to be_truthy }
    end

    context 'when the section needs review' do
      let(:status) { 'needs_review' }
      specify { expect(presenter.has_status?).to be_truthy }
    end

    context 'when the section is confirmed' do
      let(:status) { 'confirmed' }
      specify { expect(presenter.has_status?).to be_truthy }
    end

    context 'when the section is neither incomplete, needs review or confirmed' do
      let(:status) { 'some_other_status' }

      specify { expect(presenter.has_status?).to be_falsey }
    end
  end

  describe '#last_updated_info' do
    it 'returns a string containing the difference from the current time since the last update' do
      now = Time.local(2008, 9, 1, 12, 0, 0)
      Timecop.freeze(now) do
        last_updated_at = 2.days.ago
        expect(escort).to receive(:updated_at).and_return(last_updated_at)
        expect(presenter.last_updated_info).to eq('This information was last saved 2 days ago.')
      end
    end
  end

  describe '#up_to_date_warning' do
    it 'returns the localised wording for the warning' do
      expect(presenter.up_to_date_warning).to eq('Make sure all answers are up to date and check history and events in the last PER for any relevant updates.')
    end
  end
end
