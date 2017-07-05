require_relative 'concerns'
module Forms
  module Assessments
    class Answer < SimpleDelegator
      include ActiveModel::Validations
      include Concerns

      delegate :type, :has_dependencies?, to: :question

      validate :validations

      attr_reader :answer_options_dependencies, :group_answers, :complex_answers

      def initialize(assessment, question, params, options = {})
        super(assessment)
        @assessment = assessment
        @question = question
        @params = (params || {}).with_indifferent_access
        @parent = options[:parent]
        assign_answer_value
        @group_answers = build_group_answers
        @complex_answers = build_complex_answers
        @answer_options_dependencies = build_answer_options_dependencies
      end

      def find_by_name(name)
        return self if question_name.to_s == name.to_s
        match1 = find_first_match(answer_options_dependencies, :find_by_name, name)
        match2 = find_first_match(group_answers, :find_by_name, name)
        match1 || match2
      end

      def answer_options
        question.answers
      end

      def answer_options_values
        question.answer_options_values
      end

      def value
        return if question.group?
        send(question_name)
      end

      def question_name
        question.name
      end

      def present?
        value
      end

      def scope
        parent&.scope
      end

      def requires_dependencies?
        return parent.requires_dependencies? unless group_answers.empty?
        answer_schema && !answer_schema.questions.empty?
      end

      def reset
        reset_value if parent && !parent.requires_dependencies?
        answer_options_dependencies.each(&:reset)
        group_answers.each(&:reset)
      end

      def add_multiple
        return unless question.complex?
        @complex_answers << Forms::Assessments::ComplexAnswer.new(nil, question, params, parent: self)
      end

      private

      attr_reader :assessment, :question, :parent, :validators, :params

      def to_ary
        nil
      end

      def answer_schema
        question.answer_for(value)
      end

      def assign_answer_value
        if question.complex?
          return unless params["#{question_name}_attributes"]
          send("#{question_name}_attributes=", params["#{question_name}_attributes"])
        elsif params[question_name]
          send("#{question_name}=", params[question_name])
        end
      end

      def reset_value
        return unless respond_to?(question_name)
        send("#{question_name}=", nil)
      end

      def answer_dependencies
        return [] unless answer_schema
        dependency_questions_names = answer_schema.questions.map(&:name)
        answer_options_dependencies.select do |d|
          dependency_questions_names.include?(d.question_name)
        end
      end

      def validators
        question.validators
      end

      def validations
        base_validations
        validate_answer_dependencies
        validate_complex_answers
      end

      def default_options
        { in: answer_options_values, group: group_answers }
      end

      def base_validations
        validators.each do |validator|
          validator.call(self, question.name, default_options)
        end
      end

      def validate_answer_dependencies
        answer_dependencies.inject(true) do |valid, dependency|
          (dependency.valid? && valid).tap do
            dependency.errors.each do |attr, message|
              errors.add(attr, message)
            end
            dependency.errors.clear
          end
        end
      end

      def validate_complex_answers
        return unless question.complex?
        complex_answers.inject(true) do |valid, complex_answer|
          (complex_answer.valid? && valid).tap do
            complex_answer.errors.each do |attr, message|
              index = complex_answers.find_index(complex_answer)
              errors.add(:"#{question.name}_#{index}_#{attr}", message)
            end
          end
        end
      end

      def build_group_answers
        return [] unless question.group?
        question.subquestions.map do |question|
          Forms::Assessments::Answer.new(assessment, question, params, parent: self)
        end
      end

      def build_answer_options_dependencies
        question.answers.flat_map do |answer|
          answer.questions.map do |question|
            Forms::Assessments::Answer.new(assessment, question, params, parent: self)
          end
        end
      end

      def build_complex_answers
        return unless question.complex?
        return [Forms::Assessments::ComplexAnswer.new(nil, question, params, parent: self)] unless value.present?
        value.map do |complex_answer|
          Forms::Assessments::ComplexAnswer.new(complex_answer, question, params, parent: self)
        end
      end
    end
  end
end
