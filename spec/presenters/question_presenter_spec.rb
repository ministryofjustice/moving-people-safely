require 'rails_helper'

RSpec.describe QuestionPresenter do
  let(:answer_options) { [] }
  let(:question_name) { 'question_name' }
  let(:question_type) { 'string' }
  let(:question) {
    double(Forms::Assessments::Answer,
           question_name: question_name,
           type: question_type,
           answer_options: answer_options)
  }
  subject(:presenter) { described_class.new(question) }

  describe '#display_type' do
    context 'when the question type is group' do
      let(:question_type) { 'group' }
      specify { expect(presenter.display_type).to eq('fieldset') }
    end

    context 'when the question type is boolean' do
      let(:question_type) { 'boolean' }
      specify { expect(presenter.display_type).to eq('checkbox') }
    end

    context 'when the question type is date' do
      let(:question_type) { 'date' }
      specify { expect(presenter.display_type).to eq('text_field') }
    end

    context 'when the question type is string' do
      let(:question_type) { 'string' }

      context 'and there are answer options' do
        let(:answer_options) { %w[yes no] }
        specify { expect(presenter.display_type).to eq('radio_button') }
      end

      context 'and the question is a detail field' do
        let(:question_name) { 'question_name_details' }
        specify { expect(presenter.display_type).to eq('text_area') }
      end

      context 'and the question just requires a value to be inputted manually' do
        let(:question_name) { 'question_name' }
        specify { expect(presenter.display_type).to eq('text_field') }
      end
    end

    context 'when the question type is something not supported' do
      let(:question_type) { 'not-a-valid-type' }
      specify { expect(presenter.display_type).to be_nil }
    end
  end

  describe '#display_inline?' do
    context 'when the question has no answer options' do
      let(:answer_options) { [] }
      specify { expect(presenter.display_inline?).to be_falsey }
    end

    context 'when none of the answer options are the value unknown' do
      let(:answer_options) {
        [
          double(Schemas::Answer, value: 'bla'),
          double(Schemas::Answer, value: 'foo')
        ]
      }
      specify { expect(presenter.display_inline?).to be_falsey }
    end

    context 'when one of the answer options has the value unknown' do
      let(:answer_options) {
        [
          double(Schemas::Answer, value: 'bla'),
          double(Schemas::Answer, value: 'foo'),
          double(Schemas::Answer, value: 'unknown')
        ]
      }
      specify { expect(presenter.display_inline?).to be_truthy }
    end
  end

  describe '#toggle_field' do
    context 'when there are no answer options' do
      let(:answer_options) { [] }
      specify { expect(presenter.toggle_field).to be_nil }
    end

    context 'when there are answer options but they do not have any dependant questions' do
      let(:answer_options) {
        [
          double(Schemas::Answer, value: 'bla', questions: []),
          double(Schemas::Answer, value: 'foo', questions: [])
        ]
      }
      specify { expect(presenter.toggle_field).to be_nil }
    end

    context 'when there are answer options and at least one of them has dependant questions' do
      let(:answer_options) {
        [
          double(Schemas::Answer, value: 'bla', questions: []),
          double(Schemas::Answer, value: 'foo', questions: [double(Schemas::Question)]),
          double(Schemas::Answer, value: 'zzz', questions: [])
        ]
      }

      it 'returns the first answer value that has questions' do
        expect(presenter.toggle_field).to eq('foo')
      end
    end
  end
end
