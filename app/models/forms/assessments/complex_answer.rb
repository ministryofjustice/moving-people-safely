module Forms
  module Assessments
    class ComplexAnswer < SimpleDelegator
      include ActiveModel::Validations

      delegate :id, :_delete, to: :__getobj__

      validate :validations

      def initialize(answer, question, params, options = {})
        @question = question
        @params = (params || {}).with_indifferent_access
        @parent = options[:parent]
        @answer = answer || dummy_answer
        super(@answer)
        define_complex_attr_methods
      end

      def complex_attributes
        question.subquestions
      end

      def validations
        complex_validations
      end

      private

      attr_reader :question, :parent

      def dummy_answer
        attributes = complex_attributes.each_with_object({}) { |attr, h| h[attr.name] = nil }
        ComplexAttribute.new(attributes)
      end

      def complex_validations
        question.subquestions.each do |subquestion|
          subquestion.validators.each do |validator|
            validator.call(self, subquestion.name, in: subquestion.answer_options_values)
          end
        end
      end

      def define_complex_attr_methods
        complex_attributes.each do |attr|
          attr_name = attr.name.to_sym
          define_singleton_method(attr_name) { __getobj__.send(attr_name) }
        end
      end
    end
  end
end
