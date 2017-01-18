RSpec.shared_examples_for 'assessment section presenter' do
  before do
    allow(presenter).to receive(:section).and_return(section)
    allow(model).to receive(:question).and_return(answer)
    allow(model).to receive(:conditional_question).and_return(conditional_answer)
  end

  describe '#answer_for' do
    specify {
      expect(presenter).to receive(:section)
      presenter.answer_for(:question)
    }

    context 'when the question is not conditional' do
      before do
        allow(section).to receive(:question_is_conditional?).and_return(false)
      end

      context 'and the question is not answered' do
        let(:answer) { 'unknown' }

        it 'returns missing text as html' do
          expect(presenter.answer_for(:question)).
            to eq "<span class='text-error'>Missing</span>"
        end
      end

      context 'and the question is answered no' do
        let(:answer) { 'no' }

        it 'returns the No content' do
          expect(presenter.answer_for(:question)).to eq 'No'
        end
      end

      context 'and the question is answered false' do
        let(:answer) { false }

        it 'returns the No content' do
          expect(presenter.answer_for(:question)).to eq 'No'
        end
      end

      context 'and the question is answered yes' do
        let(:answer) { 'yes' }

        it 'returns the Yes content' do
          expect(presenter.answer_for(:question)).to eq '<b>Yes</b>'
        end
      end

      context 'and the question is answered true' do
        let(:answer) { true }

        it 'returns the Yes content' do
          expect(presenter.answer_for(:question)).to eq '<b>Yes</b>'
        end
      end

      context 'and the question is answered with some other value' do
        let(:answer) { 'some_other_value' }

        context 'and the answer has a locale for the summary page' do
          let(:answer) { 'some_localised_value' }

          before do
            I18n.backend.store_translations(:en, {
              summary: {
                section: {
                  answers: {
                    section_name => {
                      'some_localised_value' => 'Localised some other value'
                    }
                  }
                }
              }
            })
          end

          it 'returns the localised version of the answer' do
            expect(presenter.answer_for(:question)).to eq('Localised some other value')
          end
        end

        context 'and the answer has no locale for the summary page' do
          it 'returns the humanized version of it' do
            expect(presenter.answer_for(:question)).to eq 'Some other value'
          end
        end

        context 'and the answer is considered relevant' do
          before do
            allow(section).to receive(:relevant_answer?).with(:question, answer).and_return(true)
          end

          it 'returns the answer highlighted' do
            expect(presenter.answer_for(:question)).to eq '<b>Some other value</b>'
          end
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
          expect(presenter.answer_for(:question)).to eq 'No'
        end
      end

      context 'and the conditional question is answered yes' do
        let(:conditional_answer) { 'yes' }

        context 'and the attribute checkbox is checked' do
          let(:answer) { true }

          it 'returns yes text as html' do
            expect(presenter.answer_for(:question)).to eq '<b>Yes</b>'
          end
        end

        context 'and the attribute checkbox is unchecked' do
          let(:answer) { nil }

          it 'returns no text' do
            expect(presenter.answer_for(:question)).to eq 'No'
          end
        end
      end
    end
  end

  describe '#details_for' do
    let(:answer_detail_1) { 'foo' }
    let(:answer_detail_2) { 'bar' }

    before do
      allow(model).to receive(:question_detail_1).and_return(answer_detail_1)
      allow(model).to receive(:question_detail_2).and_return(answer_detail_2)
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
        expect(presenter.details_for(:question)).to eq('Foo. Bar')
      end

      context 'when one of the details is empty' do
        let(:answer_detail_1) { nil }

        it 'returns a string only with the details that are present' do
          expect(presenter.details_for(:question)).to eq('Bar')
        end
      end

      context 'when one of the details has a locale for its label in the summary page' do
        before do
          allow(section).to receive(:question_details).and_return(%i[localised_question_detail_1 question_detail_2])
          allow(model).to receive(:localised_question_detail_1).and_return(answer_detail_1)
          I18n.backend.store_translations(:en, {
            summary: {
              section: {
                questions: {
                  section_name => {
                    'localised_question_detail_1' => 'Localised question detail 1: '
                  }
                }
              }
            }
          })
        end

        it 'prepends the localised label for the specified detail in the returned string' do
          expect(presenter.details_for(:question)).to eq('Localised question detail 1: Foo. Bar')
        end
      end

      context 'when one of the details has a localised version for the summary page' do
        let(:answer_detail_2) { 'localised_answer_detail_2' }

        before do
          I18n.backend.store_translations(:en, {
            summary: {
              section: {
                answers: {
                  section_name => {
                    'localised_answer_detail_2' => 'Localised answer detail 2'
                  }
                }
              }
            }
          })
        end

        it 'prepends the localised label for the specified detail in the returned string' do
          expect(presenter.details_for(:question)).to eq('Foo. Localised answer detail 2')
        end
      end
    end
  end
end
