require 'rails_helper'

RSpec.describe Forms::Assessments::Answer do
  class TestClassForAssessmentAnswer
    attr_accessor :question_1, :question_11, :question_111, :question_12
  end

  let(:assessment) { TestClassForAssessmentAnswer.new }
  let(:hash) { { name: 'question_1', type: 'string' } }
  let(:question) { Schemas::Question.new(hash) }
  let(:params) { {} }
  subject(:form) { described_class.new(assessment, question, params) }

  describe '#question_name' do
    let(:hash) { { name: 'question_1', type: 'string' } }
    it 'returns the name of the question' do
      expect(form.question_name).to eq('question_1')
    end
  end

  describe '#value' do
    let(:hash) { { name: 'question_1', type: 'string' } }
    let(:params) { { question_1: 'bla' } }

    it 'returns the current value associated with the model that the form relates to' do
      expect(form.value).to eq('bla')
      assessment.question_1 = 'new_value'
      expect(form.value).to eq('new_value')
    end

    context 'when the question type is group' do
      let(:hash) { { name: 'question_1', type: 'group' } }
      specify { expect(form.value).to be_nil }
    end
  end

  describe '#present?' do
    context 'when the answer value is not set' do
      before do
        assessment.question_1 = nil
      end

      specify { expect(form.present?).to be_falsey }
    end

    context 'when the answer value is set' do
      before do
        assessment.question_1 = 'some_value'
      end

      specify { expect(form.present?).to be_truthy }
    end

    context 'when the answer value is for a question of type group' do
      let(:hash) { { name: 'question_1', type: 'group' } }

      specify { expect(form.present?).to be_falsey }
    end
  end

  describe '#scope' do
    context 'when parent is not set' do
      specify { expect(form.scope).to be_nil }
    end

    context 'when parent is set' do
      let(:parent) { double(:parent, scope: 'parent-scope') }
      subject(:form) { described_class.new(assessment, question, params, parent: parent) }

      it 'returns the parent scope' do
        expect(form.scope).to eq('parent-scope')
      end
    end
  end

  describe '#requires_dependencies?' do
    let(:parent) { double(:parent, requires_dependencies?: false) }
    let(:params) { { question_1: 'some_value' } }
    let(:hash) { { name: 'question_1', type: 'string' } }
    subject(:form) { described_class.new(assessment, question, params, parent: parent) }

    specify { expect(form.requires_dependencies?).to be_falsey }

    context 'when the question is compounded by a group of dependent questions' do
      let(:hash) {
        {
          name: 'question_1',
          type: 'group',
          questions: [
            { name: 'question_11', type: 'string' },
            { name: 'question_12', type: 'string' }
          ]
        }
      }

      it 'returns the parent dependencies requirement' do
        expect(form.requires_dependencies?).to be_falsey
      end
    end

    context 'when the question has a set of answer options available' do
      let(:params) { { question_1: 'answer_2' } }
      let(:hash) {
        {
          name: 'question_1',
          type: 'string',
          answers: answers
        }
      }

      context 'but none of the answers requires additional questions to be answered' do
        let(:answers) {
          [
            { value: 'answer_1' },
            { value: 'answer_2' }
          ]
        }

        specify { expect(form.requires_dependencies?).to be_falsey }
      end

      context 'and at least one of the answers requires additional questions to be answered' do
        let(:answers) {
          [
            { value: 'answer_1' },
            { value: 'answer_2', questions: [{ name: 'question_11', type: 'string' }] }
          ]
        }

        specify { expect(form.requires_dependencies?).to be_truthy }
      end
    end
  end

  describe '#valid?' do
    context 'when answer for the question was not provided' do
      let(:params) { { some_other_question: 'some_other_answer' } }

      context 'but the question has no validations' do
        let(:hash) { { name: 'question_1', type: 'string' } }
        specify { expect(form).to be_valid }
      end

      context 'and the question has validations' do
        let(:hash) {
          {
            name: 'question_1',
            type: 'string',
            validators: [
              { name: 'Assessments::PresenceValidator' }
            ]
          }
        }

        context 'and at least one of the validations fails' do
          it 'returns false and contains validation errors' do
            expect(form).not_to be_valid
            expect(form.errors[:question_1]).to match_array([I18n.t(:blank, scope: 'errors.messages')])
          end
        end

        context 'and all the validations pass' do
          let(:hash) {
            {
              name: 'question_1',
              type: 'string',
              validators: [
                { name: 'Assessments::PresenceValidator', options: { allow_nil: true } }
              ]
            }
          }
          specify { expect(form).to be_valid }
        end
      end
    end

    context 'when answer for the question was provided' do
      let(:params) { { question_1: 'some_answer' } }

      context 'but the question has no validations' do
        let(:hash) { { name: 'question_1', type: 'string' } }
        specify { expect(form).to be_valid }
      end

      context 'and the question has validations' do
        context 'and at least one of the validations fails' do
          let(:params) { { question_1: '' } }
          let(:hash) {
            {
              name: 'question_1',
              type: 'string',
              validators: [
                { name: 'Assessments::PresenceValidator', options: { allow_blank: false } }
              ]
            }
          }
          it 'returns false and sets validation errors' do
            expect(form).not_to be_valid
            expect(form.errors[:question_1]).to match_array([I18n.t(:blank, scope: 'errors.messages')])
          end
        end

        context 'and all the validations pass' do
          let(:hash) {
            {
              name: 'question_1',
              type: 'string',
              validators: [
                { name: 'Assessments::PresenceValidator' }
              ]
            }
          }
          specify { expect(form).to be_valid }
        end
      end
    end
  end

  describe '#reset' do
    context 'when the question has no dependencies' do
      let(:hash) { { name: 'question_1', type: 'string' } }
      let(:params) { { question_1: 'no' } }

      it 'keeps the submitted answer value unchanged' do
        expect(form.value).to eq('no')
        expect { form.reset }.not_to change { assessment.question_1 }.from('no')
      end
    end

    context 'when the question has answers with dependencies' do
      let(:hash) {
        {
          name: 'question_1',
          type: 'string',
          answers: [
            {
              value: 'yes',
              questions: [
                {
                  name: 'question_11',
                  type: 'string',
                  answers: [
                    {
                      value: 'yes',
                      questions: [
                        {
                          name: 'question_111',
                          type: 'string'
                        }
                      ]
                    },
                    { value: 'no' }
                  ]
                },
                {
                  name: 'question_12',
                  type: 'string',
                }
              ]
            },
            { value: 'no' }
          ]
        }
      }
      let(:assessment) {
        TestClassForAssessmentAnswer.new.tap do |a|
          a.question_1 = 'yes'
          a.question_11 = 'yes'
          a.question_111 = 'previously_set'
          a.question_12 = 'yes'
        end
      }

      context 'and the answer given does not require additional answers' do
        let(:params) { { question_1: 'no', question_11: 'yes', question_111: 'new_value' } }

        it 'keeps the submitted answer value unchanged' do
          expect(form.value).to eq('no')
          expect { form.reset }.not_to change { assessment.question_1 }.from('no')
        end

        it 'resets any other answer dependencies previously set' do
          initial_values = ['yes', 'previously_set', 'yes']
          reset_values = [nil, nil, nil]
          expect { form.reset }
            .to change {
              [assessment.question_11, assessment.question_111, assessment.question_12]
            }.from(initial_values).to(reset_values)
        end
      end

      context 'and the answer given does requires additional answers' do
        let(:params) { { question_1: 'yes', question_11: 'no' } }

        it 'keeps the submitted answer value unchanged' do
          expect(form.value).to eq('yes')
          expect(assessment.question_11).to eq('no')
          initial_values = ['yes', 'no', 'yes']
          expect { form.reset }
            .not_to change {
              [assessment.question_1, assessment.question_11, assessment.question_12]
            }.from(initial_values)
        end

        it 'resets any other answer dependencies previously set not required' do
          expect { form.reset }
            .to change { assessment.question_111 }.from('previously_set').to(nil)
        end
      end
    end

    context 'when the question is compounded of group of questions to be answered' do
      let(:hash) {
        {
          name: 'question_1',
          type: 'string',
          answers: [
            {
              value: 'yes',
              questions: [
                {
                  name: 'question_1_type',
                  type: 'group',
                  questions: [
                    {
                      name: 'question_11',
                      type: 'string',
                      answers: [
                        {
                          value: 'yes',
                          questions: [
                            {
                              name: 'question_111',
                              type: 'string'
                            }
                          ]
                        },
                        { value: 'no' }
                      ]
                    },
                    {
                      name: 'question_12',
                      type: 'string',
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
      let(:assessment) {
        TestClassForAssessmentAnswer.new.tap do |a|
          a.question_1 = 'yes'
          a.question_11 = 'yes'
          a.question_111 = 'previously_set'
          a.question_12 = 'yes'
        end
      }

      context 'and the answer given does not require additional answers' do
        let(:params) { { question_1: 'no' } }

        it 'keeps the submitted answer value unchanged' do
          expect(form.value).to eq('no')
          expect { form.reset }.not_to change { assessment.question_1 }.from('no')
        end

        it 'resets related group answers previously set' do
          initial_values = ['yes', 'previously_set', 'yes']
          reset_values = [nil, nil, nil]
          expect { form.reset }
            .to change {
              [assessment.question_11, assessment.question_111, assessment.question_12]
            }.from(initial_values).to(reset_values)
        end
      end

      context 'and the answer given does requires some of compounded group answers' do
        let(:params) { { question_1: 'yes', question_11: 'no', question_12: 'yes' } }

        it 'keeps the submitted answer value unchanged' do
          expect(form.value).to eq('yes')
          expect(assessment.question_11).to eq('no')
          initial_values = ['yes', 'no', 'yes']
          expect { form.reset }
            .not_to change {
              [assessment.question_1, assessment.question_11, assessment.question_12]
            }.from(initial_values)
        end

        it 'resets any other answer dependencies previously set not required' do
          expect { form.reset }
            .to change { assessment.question_111 }.from('previously_set').to(nil)
        end
      end
    end
  end
end
