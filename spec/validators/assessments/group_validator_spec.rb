require 'rails_helper'

RSpec.describe Assessments::GroupValidator do
  class TestGroupValidatable
    include ActiveModel::Validations
    attr_accessor :test_attr

    def initialize(test_attr)
      @test_attr = test_attr
    end
  end

  class TestGroupElem
    include ActiveModel::Validations
    attr_reader :question_name, :answer, :scope

    validates :answer, presence: { message: ->(object, _data) { "error on #{object.question_name}"} }

    def initialize(question_name, answer, scope, options = {})
      @question_name = question_name
      @answer = answer
      @scope = scope
      @present = options.fetch(:present, true)
      @valid = options.fetch(:validate, true)
    end

    def present?
      @present
    end
  end

  let(:attr_value) { 'some_value' }
  let(:validatable) { TestGroupValidatable.new(test_attr: attr_value) }
  let(:options) { { group: double(:group) } }
  subject(:validator) { described_class.new(validatable, :test_attr, options) }

  describe '#call' do
    context 'when :at_least option is not provided' do
      it 'does not contain any errors since it does not perform any validation' do
        validator.call
        expect(validatable.errors).to be_empty
      end
    end

    context 'when :at_least option is provided' do
      let(:options) { { at_least: true, group: group } }

      context 'and there no group elements present' do
        before do
          localize_key('activemodel.errors.models.test_group_validatable.attributes.base.minimum_one_option', 'Select one option from the test group')
          localize_key('helpers.label.some_scope.elem1', 'ELEM 1')
          localize_key('helpers.label.some_scope.elem2', 'ELEM 2')
        end

        let(:group) {
          [
            double(:elem, question_name: 'elem1', scope: 'some_scope', present?: false),
            double(:elem, question_name: 'elem2', scope: 'some_scope', present?: false)
          ]
        }

        it 'adds a minimum one option error to the validatable record' do
          validator.call
          expect(validatable.errors).not_to be_empty
          expect(validatable.errors[:base]).to match_array(['Select one option from the test group'])
        end

        context 'with a custom error message' do
          let(:message) { 'This is a custom error message' }
          let(:options) { { at_least: true, group: group, message: message } }

          it 'adds the custom error message to the validatable record' do
            validator.call
            expect(validatable.errors).not_to be_empty
            expect(validatable.errors[:base]).to match_array(['This is a custom error message'])
          end
        end
      end

      context 'and there is at least a group element present' do
        let(:elem1) { TestGroupElem.new('elem2', 'whatever', 'some_scope', present: false) }
        let(:elem2) { TestGroupElem.new('elem2', answer2, 'some_scope') }
        let(:elem3) { TestGroupElem.new('elem3', answer3, 'some_scope') }
        let(:group) { [elem1, elem2, elem3] }

        context 'and all present elements are valid' do
          let(:answer2) { 'answer 2' }
          let(:answer3) { 'answer 3' }

          it 'does not contain any errors' do
            validator.call
            expect(validatable.errors).to be_empty
          end
        end

        context 'and some of the present elements are not valid' do
          let(:answer2) { nil }
          let(:answer3) { '' }

          it 'contain all the errors from the non-valid elements' do
            validator.call
            expect(validatable.errors).not_to be_empty
            expect(validatable.errors.full_messages).to match_array(["Answer error on elem2", "Answer error on elem3"])
          end
        end
      end
    end
  end
end
