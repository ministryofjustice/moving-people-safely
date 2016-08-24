require 'rails_helper'

RSpec.describe Summary::ViolencePresenter, type: :presenter do
  let(:model) { instance_double(Risk) }
  subject { described_class.new(model) }

  # it already implements the details_for method etc
  it { is_expected.to be_a SummaryPresenter }

  describe '#answer_for' do
    context 'when the violence question is unanswered' do
      let(:model) { instance_double(Risk, violent: 'unknown') }

      it 'returns missing text as html' do
        expect(subject.answer_for(:some_attribute)).
          to eq "<span class='text-error'>Missing</span>"
      end
    end

    context 'when the violence question is answered no' do
      let(:model) { instance_double(Risk, violent: 'no') }

      it 'returns no text' do
        expect(subject.answer_for(:some_attribute)).to eq 'No'
      end
    end

    context 'when the violence question is answered yes' do
      context 'when the attribute checkbox is checked' do
        let(:model) { instance_double(Risk, violent: 'yes', prison_staff: true) }

        it 'returns yes text as html' do
          expect(subject.answer_for(:prison_staff)).to eq '<b>Yes</b>'
        end
      end

      context 'when the attribute checkbox is unchecked' do
        let(:model) { instance_double(Risk, violent: 'yes', prison_staff: nil) }

        it 'returns no text' do
          expect(subject.answer_for(:prison_staff)).to eq 'No'
        end
      end
    end
  end
end
