require_relative 'concerns'
module Forms
  module Assessments
    class Section < SimpleDelegator
      extend ActiveModel::Naming
      extend ActiveModel::Translation
      include Forms::Assessments::Concerns
      attr_reader :answers, :errors

      def initialize(assessment, section, params, options = {})
        super(assessment)
        @assessment = assessment
        @section = section
        @params = params
        @answers = build_answers(params)
        @parent = options[:parent]
        @errors = ActiveModel::Errors.new(self)
      end

      def add_multiple(name)
        question = find_first_match(answers, :find_by_name, name)
        question&.add_multiple
      end

      def name
        section.name
      end

      def scope
        return parent.scope if parent
        name
      end

      def valid?
        answers.inject(true) do |valid, answer|
          (answer.valid? && valid).tap do
            answer.errors.each do |attr, message|
              errors.add(attr, message)
            end
            answer.errors.clear
          end
        end
      end

      def requires_dependencies?
        true
      end

      def reset
        answers.each(&:reset)
      end

      def save
        reset
        super
      end

      private

      attr_reader :assessment, :section, :parent
      delegate :read_attribute_for_validation, to: :__getobj__

      def to_ary
        nil
      end

      def build_answers(params)
        section.questions.map do |question|
          Forms::Assessments::Answer.new(assessment, question, params, parent: self)
        end
      end
    end
  end
end
