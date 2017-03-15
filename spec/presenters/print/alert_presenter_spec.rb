require 'rails_helper'

RSpec.describe Print::AlertPresenter, type: :presenter do
  let(:name) { :some_alert }
  let(:status) { :off }
  let(:default_options) { { view_context: view } }
  let(:options) { { status: status }.merge(default_options) }

  subject(:presenter) { described_class.new(name, options) }

  describe '#title' do
    context 'when the title is provided' do
      let(:options) { { status: status, title: 'Provided title' }.merge(default_options) }

      it 'returns the provided title' do
        expect(presenter.title).to eq('Provided title')
      end
    end

    context 'when there is no locale for the alert title' do
      it 'returns the humanized version of the alert' do
        expect(presenter.title).to eq('Some alert')
      end
    end

    context 'when there is a locale for the alert title' do
      let(:name) { :some_localised_alert }

      before do
        localize_key("print.alerts.title.#{name}", 'Localised alert name')
      end

      it 'returns the locale version of the alert' do
        expect(presenter.title).to eq('Localised alert name')
      end
    end
  end

  describe '#to_s' do
    context 'when the alert is off' do
      let(:status) { :off }

      it 'returns the appropriate content for when the alert is off' do
        expect(presenter.to_s).to eq('<div class="alert-wrapper"><div class="image alert-off"><span class="alert-title">Some alert</span></div></div>')
      end
    end

    context 'when the alert is on' do
      let(:status) { :on }

      it 'returns the appropriate content for when the alert is on' do
        expect(presenter.to_s).to match('<div class="image alert-on"><span class="alert-title">Some alert</span>')
        expect(presenter.to_s).to match('<img src=.* alt="Ic red tick"')
      end
    end

    context 'when the alert has no additional text' do
      it 'returs the appropriate content without any additional text' do
        expect(presenter.to_s).not_to match('<span class="alert-text">')
      end
    end

    context 'when the alert has additional text' do
      let(:text) { 'some additional text' }
      let(:options) { { status: status, text: text }.merge(default_options) }

      it 'returs the appropriate content without any additional text' do
        expect(presenter.to_s).to match('<span class="alert-text">')
      end
    end
  end
end
