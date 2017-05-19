require 'rails_helper'

RSpec.describe AssessmentIntroPresenter, type: :presenter do
  let(:name) { 'some_assessment' }

  subject(:presenter) { described_class.new(name) }

  describe '#title' do
    context 'when there is no locale for the title' do
      it 'returns the humanised version of the title' do
        expect(presenter.title).to eq('<span class="translation_missing" title="translation missing: en.some_assessment.intro.title">Title</span>')
      end
    end

    context 'when there is a locale for the title' do
      let(:name) { 'some_localised_assessment' }

      before do
        localize_key("#{name}.intro.title", 'Localised intro title')
      end

      it 'returns the localised title' do
        expect(presenter.title).to eq('Localised intro title')
      end
    end
  end

  describe '#contents' do
    context 'when there is no locale for the contents' do
      it 'returns an empty array' do
        expect(presenter.contents).to eq([])
      end
    end

    context 'when tere is a locale for the contents' do
      let(:name) { 'some_localised_assessment' }

      before do
        localize_key("#{name}.intro.content", "Line 1\n\nLine 2")
      end

      it 'returns an array with the localised contents separated by new lines' do
        expect(presenter.contents).to eq(['Line 1','', 'Line 2'])
      end
    end
  end

  describe '#notes' do
    context 'when there is no locale for the notes' do
      it 'returns an empty array' do
        expect(presenter.notes).to eq([])
      end
    end

    context 'when tere is a locale for the notes' do
      let(:name) { 'some_localised_assessment' }

      before do
        localize_key("#{name}.intro.note", "Note 1\n\nNote 2")
      end

      it 'returns an array with the localised notes separated by new lines' do
        expect(presenter.notes).to eq(['Note 1','', 'Note 2'])
      end
    end
  end
end
