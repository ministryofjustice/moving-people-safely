require 'rails_helper'

RSpec.describe Summary::EscortSectionStatusPresenter, type: :presenter do
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
end
