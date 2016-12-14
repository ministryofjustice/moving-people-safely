require 'rails_helper'

RSpec.describe Summary::Risks::ViolenceSectionPresenter, type: :presenter do
  let(:answer) { true }
  let(:conditional_answer) { 'yes' }
  let(:model) { double(Risk) }
  let(:section_name) { 'violence' }
  let(:section) { instance_double(RiskAssessment::ViolenceSection) }
  subject { described_class.new(model, section: section_name) }

  it { is_expected.to be_a SummaryPresenter }

  before do
    allow(subject).to receive(:section).and_return(section)
    allow(model).to receive(:question).and_return(answer)
    allow(model).to receive(:conditional_question).and_return(conditional_answer)
  end

  describe '#answer_for' do
    context 'when the question is not conditional' do
      before do
        allow(section).to receive(:question_is_conditional?).and_return(false)
      end

      context 'and the question is not answered' do
        let(:answer) { 'unknown' }

        it 'returns missing text as html' do
          expect(subject.answer_for(:question)).
            to eq "<span class='text-error'>Missing</span>"
        end
      end

      context 'and the question is answered no' do
        let(:answer) { 'no' }

        it 'returns the No content' do
          expect(subject.answer_for(:question)).to eq 'No'
        end
      end

      context 'and the question is answered false' do
        let(:answer) { false }

        it 'returns the No content' do
          expect(subject.answer_for(:question)).to eq 'No'
        end
      end

      context 'and the question is answered yes' do
        let(:answer) { 'yes' }

        it 'returns the Yes content' do
          expect(subject.answer_for(:question)).to eq '<b>Yes</b>'
        end
      end

      context 'and the question is answered true' do
        let(:answer) { true }

        it 'returns the Yes content' do
          expect(subject.answer_for(:question)).to eq '<b>Yes</b>'
        end
      end
    end

    context 'when the question is conditional' do
      before do
        allow(section).to receive(:question_is_conditional?).and_return(true)
        allow(section).to receive(:question_condition).and_return(:conditional_question)
      end

      context 'and the conditional question is answered no' do
        let(:conditional_answer) { 'no' }

        it 'returns no text' do
          expect(subject.answer_for(:question)).to eq 'No'
        end
      end

      context 'and the conditional question is answered yes' do
        let(:conditional_answer) { 'yes' }

        context 'and the attribute checkbox is checked' do
          let(:answer) { true }

          it 'returns yes text as html' do
            expect(subject.answer_for(:question)).to eq '<b>Yes</b>'
          end
        end

        context 'and the attribute checkbox is unchecked' do
          let(:answer) { nil }

          it 'returns no text' do
            expect(subject.answer_for(:question)).to eq 'No'
          end
        end
      end
    end
  end
end
