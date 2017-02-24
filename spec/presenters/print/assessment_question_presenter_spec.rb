require 'rails_helper'

RSpec.describe Print::AssessmentQuestionPresenter do
  let(:question) { 'some_question' }
  let(:answer) { 'some_answer' }
  let(:section_name) { 'some_section' }
  let(:section_klass) {
    Class.new(BaseSection) do
      def initialize(section_name)
        @section_name = section_name
      end

      def name
        @section_name
      end
    end
  }
  let(:section) { section_klass.new(section_name) }
  let(:assessment) { double(:assessment) }

  subject(:presenter) { described_class.new(question, assessment, section) }

  before do
    allow(assessment).to receive(question).and_return(answer)
  end

  describe '#label' do
    before do
      localize_key("summary.section.questions.#{section_name}.#{question}", 'Localised question')
    end

    context 'when the answer is relevant' do
      before do
        allow(presenter).to receive(:answer_is_relevant?).and_return(true)
      end

      it 'returns the highlighted label' do
        expect(presenter.label).to eq('<div class="strong-text">Localised question</div>')
      end
    end

    it 'returns the normal non-highlighted label' do
      expect(presenter.label).to eq('<div class="title">Localised question</div>')
    end
  end

  describe '#answer' do
    context 'when the question is not conditional' do
      before do
        allow(section).to receive(:question_is_conditional?).and_return(false)
      end

      context 'and the question is answered no' do
        let(:answer) { 'no' }

        it 'returns the No content' do
          expect(presenter.answer).to eq 'No'
        end
      end

      context 'and the question is answered false' do
        let(:answer) { false }

        it 'returns the No content' do
          expect(presenter.answer).to eq 'No'
        end
      end

      context 'and the question is answered yes' do
        let(:answer) { 'yes' }

        it 'returns the Yes content' do
          expect(presenter.answer).to eq '<div class="strong-text">Yes</div>'
        end
      end

      context 'and the question is answered true' do
        let(:answer) { true }

        it 'returns the Yes content' do
          expect(presenter.answer).to eq '<div class="strong-text">Yes</div>'
        end
      end

      context 'and the question is answered with some other value' do
        let(:answer) { 'some_other_value' }

        context 'and the answer has a locale for the summary page' do
          let(:answer) { 'some_localised_value' }

          before do
            localize_key("summary.section.answers.#{section_name}.some_localised_value", 'Localised some other value')
          end

          it 'returns the localised version of the answer' do
            expect(presenter.answer).to eq('Localised some other value')
          end
        end

        context 'and the answer has no locale for the summary page' do
          it 'returns the humanized version of it' do
            expect(presenter.answer).to eq 'Some other value'
          end
        end

        context 'and the answer is considered relevant' do
          before do
            allow(section).to receive(:relevant_answer?).with(question, answer).and_return(true)
          end

          it 'returns the answer highlighted' do
            expect(presenter.answer).to eq '<div class="strong-text">Some other value</div>'
          end
        end
      end
    end

    context 'when the question is conditional' do
      before do
        allow(assessment).to receive(:conditional_question).and_return(conditional_answer)
        allow(section).to receive(:question_is_conditional?).and_return(true)
        allow(section).to receive(:question_condition).and_return(:conditional_question)
      end

      context 'and the conditional question is answered no' do
        let(:conditional_answer) { 'no' }

        it 'returns no text' do
          expect(presenter.answer).to eq 'No'
        end
      end

      context 'and the conditional question is answered yes' do
        let(:conditional_answer) { 'yes' }

        context 'and the attribute checkbox is checked' do
          let(:answer) { true }

          it 'returns yes text highlighted' do
            expect(presenter.answer).to eq '<div class="strong-text">Yes</div>'
          end
        end

        context 'and the attribute checkbox is unchecked' do
          let(:answer) { nil }

          it 'returns no text' do
            expect(presenter.answer).to eq 'No'
          end
        end
      end
    end
  end

  describe '#answer_is_relevant?' do
    context 'when the question is not conditional' do
      before do
        allow(section).to receive(:question_is_conditional?).and_return(false)
      end

      context 'and the question is answered no' do
        let(:answer) { 'no' }

        specify { expect(presenter.answer_is_relevant?).to be_falsey }
      end

      context 'and the question is answered false' do
        let(:answer) { false }

        specify { expect(presenter.answer_is_relevant?).to be_falsey }
      end

      context 'and the question is answered yes' do
        let(:answer) { 'yes' }

        specify { expect(presenter.answer_is_relevant?).to be_truthy }
      end

      context 'and the question is answered true' do
        let(:answer) { true }

        specify { expect(presenter.answer_is_relevant?).to be_truthy }
      end

      context 'and the question is answered with some other value' do
        let(:answer) { 'some_other_value' }

        specify { expect(presenter.answer_is_relevant?).to be_falsey }

        context 'and the answer is considered relevant' do
          before do
            allow(section).to receive(:relevant_answer?).with(question, answer).and_return(true)
          end

          specify { expect(presenter.answer_is_relevant?).to be_truthy }
        end
      end
    end

    context 'when the question is conditional' do
      before do
        allow(assessment).to receive(:conditional_question).and_return(conditional_answer)
        allow(section).to receive(:question_is_conditional?).and_return(true)
        allow(section).to receive(:question_condition).and_return(:conditional_question)
      end

      context 'and the conditional question is answered no' do
        let(:conditional_answer) { 'no' }

         specify { expect(presenter.answer_is_relevant?).to be_falsey }
      end

      context 'and the conditional question is answered yes' do
        let(:conditional_answer) { 'yes' }

        context 'and the attribute checkbox is checked' do
          let(:answer) { true }

          specify { expect(presenter.answer_is_relevant?).to be_truthy }
        end

        context 'and the attribute checkbox is unchecked' do
          let(:answer) { nil }

          specify { expect(presenter.answer_is_relevant?).to be_falsey }
        end
      end
    end
  end

  describe '#details' do
    let(:answer_detail_1) { 'foo' }
    let(:answer_detail_2) { 'bar' }

    before do
      allow(assessment).to receive(:question_detail_1).and_return(answer_detail_1)
      allow(assessment).to receive(:question_detail_2).and_return(answer_detail_2)
    end

    context 'when the question has no defined details' do
      before do
        allow(section).to receive(:question_has_details?).and_return(false)
      end
    end

    context 'when the question has defined details' do
      before do
        allow(section).to receive(:question_has_details?).and_return(true)
        allow(section).to receive(:question_details).and_return(%i[question_detail_1 question_detail_2])
      end

      it 'returns a string with the combined details for the question' do
        expect(presenter.details).to eq('Foo. Bar')
      end

      context 'when one of the details is empty' do
        let(:answer_detail_1) { nil }

        it 'returns a string only with the details that are present' do
          expect(presenter.details).to eq('Bar')
        end
      end

      context 'when one of the details has a locale for its label in the summary page' do
        before do
          allow(section).to receive(:question_details).and_return(%i[localised_question_detail_1 question_detail_2])
          allow(assessment).to receive(:localised_question_detail_1).and_return(answer_detail_1)
          localize_key("summary.section.questions.#{section_name}.localised_question_detail_1", 'Localised question detail 1: ')
        end

        it 'prepends the localised label for the specified detail in the returned string' do
          expect(presenter.details).to eq('Localised question detail 1: Foo. Bar')
        end
      end

      context 'when one of the details has a localised version for the summary page' do
        let(:answer_detail_2) { 'localised_answer_detail_2' }

        before do
          localize_key("summary.section.answers.#{section_name}.localised_answer_detail_2", 'Localised answer detail 2')
        end

        it 'prepends the localised label for the specified detail in the returned string' do
          expect(presenter.details).to eq('Foo. Localised answer detail 2')
        end
      end
    end
  end
end
