require 'rails_helper'

RSpec.describe Summary::AssessmentQuestionPresenter do
  let(:section_name) { 'some_section' }
  let(:question_name) { 'some_question' }
  let(:value) { 'some_value' }
  let(:question) {
    instance_double(Assessments::Question,
                    name: question_name,
                    section_name: section_name,
                    value: value
                   )
  }
  subject(:presenter) { described_class.new(question) }

  describe '#label' do
    it 'returns the humanised version of the question name' do
      expect(presenter.label).to eq('<span class="translation_missing" title="translation missing: en.summary.section.questions.some_section.some_question">Some Question</span>')
    end

    context 'when there is a locale for the question name' do
      let(:question_name) { 'some_localised_question' }
      before do
        localize_key("summary.section.questions.#{section_name}.#{question_name}", 'Localised question')
      end

      it 'returns the localised label for the question name' do
        expect(presenter.label).to eq('Localised question')
      end
    end
  end

  describe '#answer' do
    shared_examples_for 'format answered value' do
      context 'when the answer for the question is "no"' do
        let(:value) { 'no' }

        it 'returns No' do
          expect(presenter.answer).to eq('No')
        end
      end

      context 'when the answer for the question is false' do
        let(:value) { false }

        it 'returns No' do
          expect(presenter.answer).to eq('No')
        end
      end

      context 'when the answer for the question is "yes"' do
        let(:value) { 'yes' }

        it 'returns Yes' do
          expect(presenter.answer).to eq('<b>Yes</b>')
        end
      end

      context 'when the answer for the question is true' do
        let(:value) { true }

        it 'returns Yes' do
          expect(presenter.answer).to eq('<b>Yes</b>')
        end
      end

      context 'when the answer for the question is some other value' do
        let(:value) { 'some_other_value' }

        context 'and the answer is not considered relevant' do
          before do
            expect(question).to receive(:relevant_answer?).and_return(false)
          end

          it 'returns the non-highlighted answer' do
            expect(presenter.answer).to eq('Some other value')
          end

          context 'and has a locale for the answer' do
            let(:value) { 'some_localised_value' }
            before do
              localize_key("summary.section.answers.#{section_name}.#{value}", 'Localised answer')
            end

            it 'returns the locale for the non-highlighted answer' do
              expect(presenter.answer).to eq('Localised answer')
            end
          end
        end

        context 'and the answer is considered relevant' do
          before do
            expect(question).to receive(:relevant_answer?).and_return(true)
          end

          it 'returns the highlighted answer' do
            expect(presenter.answer).to eq('<b>Some other value</b>')
          end

          context 'and has a locale for the answer' do
            let(:value) { 'some_other_localised_value' }
            before do
              localize_key("summary.section.answers.#{section_name}.#{value}", 'Localised answer')
            end

            it 'returns the locale for the highlighted answer' do
              expect(presenter.answer).to eq('<b>Localised answer</b>')
            end
          end
        end
      end
    end

    context 'when question does not belong to a group of questions' do
      before do
        expect(question).to receive(:belongs_to_group?).and_return(false)
      end

      context 'when the answer for the question is "unknown"' do
        let(:value) { 'unknown' }

        it 'returns missing content' do
          expect(presenter.answer).to eq("<span class='text-error'>Missing</span>")
        end
      end

      context 'when the answer for the question is nil' do
        let(:value) { nil }

        it 'returns missing content' do
          expect(presenter.answer).to eq("<span class='text-error'>Missing</span>")
        end
      end

      include_examples 'format answered value'
    end

    context 'when question belongs to a group of questions' do
      before do
        expect(question).to receive(:belongs_to_group?).and_return(true)
      end

      context 'and group parent answer is "unknown"' do
        before do
          expect(question).to receive(:parent_group_answer).and_return('unknown')
        end

        it 'returns missing content' do
          expect(presenter.answer).to eq("<span class='text-error'>Missing</span>")
        end
      end

      context 'and group parent answer is nil' do
        before do
          expect(question).to receive(:parent_group_answer).and_return(nil)
        end

        it 'returns missing content' do
          expect(presenter.answer).to eq("<span class='text-error'>Missing</span>")
        end
      end

      context 'and group parent answer is "no"' do
        before do
          expect(question).to receive(:parent_group_answer).and_return('no')
        end

        it 'returns No' do
          expect(presenter.answer).to eq('No')
        end
      end

      context 'and group parent answer is false' do
        before do
          expect(question).to receive(:parent_group_answer).and_return(false)
        end

        it 'returns No' do
          expect(presenter.answer).to eq('No')
        end
      end

      context 'and group parent answer is present and relevant' do
        before do
          expect(question).to receive(:parent_group_answer).and_return('yes')
        end

        include_examples 'format answered value'
      end
    end
  end

  describe '#details' do
    context 'when the answer has no dependencies' do
      before do
        expect(question).to receive(:has_dependencies?).and_return(false)
      end

      it 'returns empty details' do
        expect(presenter.details).to be_nil
      end
    end
  end
end
