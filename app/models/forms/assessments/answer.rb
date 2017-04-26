module Forms
  module Assessments
    class Answer < SimpleDelegator
      include ActiveModel::Validations

      validate :validations

      attr_reader :parent

      def initialize(assessment, question, params, options = {})
        super(assessment)
        @assessment = assessment
        @question = question
        @params = (params || {}).with_indifferent_access
        assign_answer_value
        @parent = options[:parent]
        @group_answers = build_group_answers
        @answer_options = build_answer_options
        @answer_dependencies = build_answer_dependencies
      end

      def value
        return if question.type == 'group'
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
        answer_options.each(&:reset)
        group_answers.each(&:reset)
      end

      private

      attr_reader :assessment, :question, :validators,
        :answer_options, :answer_dependencies, :group_answers, :params

      def answer_schema
        question.answer_for(value)
      end

      def assign_answer_value
        if params[question_name]
          send("#{question_name}=", params[question_name])
        end
      end

      def reset_value
        return unless respond_to?(question_name)
        send("#{question_name}=", nil)
      end

      def validators
        question.validators
      end

      def validations
        base_validations
        validate_answer_dependencies
      end

      def default_options
        { in: question.answer_options, group: group_answers }
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
          end
        end
      end

      def build_group_answers
        question.subquestions.map do |question|
          Forms::Assessments::Answer.new(assessment, question, params, parent: self)
        end
      end

      def build_answer_options
        question.answers.flat_map do |answer|
          answer.questions.map do |question|
            Forms::Assessments::Answer.new(assessment, question, params, parent: self)
          end
        end
      end

      def build_answer_dependencies
        return [] unless answer_schema
        answer_schema.questions.map do |question|
          Forms::Assessments::Answer.new(assessment, question, params, parent: self)
        end
      end
    end
  end
end
