require 'rails_helper'

RSpec.describe RadioDatePickerPresenter do
  let(:attr) { 'some_attr' }
  let(:value) { Date.civil(2007, 7, 23) }
  let(:travel_date) { Date.civil(2016, 11, 24) }
  subject(:picker) { described_class.new(attr, value) }

  around do |example|
    travel_to(travel_date) do
      example.run
    end
  end

  describe '#today_label' do
    specify { expect(picker.today_label).to eq('some_attr_24/11/2016') }

    context 'for an attribute that needs to be normalised' do
      let(:attr) { 'context[some_attr]' }
      specify { expect(picker.today_label).to eq('context_some_attr_24/11/2016') }
    end
  end

  describe '#tomorrow_label' do
    specify { expect(picker.tomorrow_label).to eq('some_attr_25/11/2016') }

    context 'for an attribute that needs to be normalised' do
      let(:attr) { 'context[some_attr]' }
      specify { expect(picker.tomorrow_label).to eq('context_some_attr_25/11/2016') }
    end
  end

  describe '#today' do
    context 'when no format is specified' do
      it 'returns today date using the default format' do
        expect(picker.today).to eq('24/11/2016')
      end
    end

    context 'when a format is specified' do
      it 'returns today date using the provided format' do
        expect(picker.today('%Y-%m-%d')).to eq('2016-11-24')
      end
    end
  end

  describe '#tomorrow' do
    context 'when no format is specified' do
      it 'returns tomorrow date using the default format' do
        expect(picker.tomorrow).to eq('25/11/2016')
      end
    end

    context 'when a format is specified' do
      it 'returns tomorrow date using the provided format' do
        expect(picker.tomorrow('%Y-%m-%d')).to eq('2016-11-25')
      end
    end
  end

  describe '#today?' do
    context 'when the provided value is not today' do
      let(:value) { Date.civil(2007, 7, 23) }
      let(:travel_date) { Date.civil(2016, 11, 24) }
      specify { expect(picker.today?).to be_falsey }
    end

    context 'when the provided value is today' do
      let(:value) { travel_date }
      let(:travel_date) { Date.civil(2016, 11, 24) }
      specify { expect(picker.today?).to be_truthy }
    end
  end

  describe '#tomorrow?' do
    context 'when the provided value is not tomorrow' do
      let(:value) { Date.civil(2007, 7, 23) }
      let(:travel_date) { Date.civil(2016, 11, 24) }
      specify { expect(picker.tomorrow?).to be_falsey }
    end

    context 'when the provided value is tomorrow' do
      let(:value) { Date.civil(2016, 11, 25) }
      let(:travel_date) { Date.civil(2016, 11, 24) }
      specify { expect(picker.tomorrow?).to be_truthy }
    end
  end
end
