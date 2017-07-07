require_relative 'concerns'
module Forms
  module Assessments
    class Section < SimpleDelegator
      extend ActiveModel::Naming
      extend ActiveModel::Translation
      include Forms::Assessments::Concerns
      attr_reader :answers, :subsections, :errors

      def initialize(assessment, section, params, options = {})
        super(assessment)
        @assessment = assessment
        @section = section
        @params = params
        @subsections = build_subsections(params)
        @answers = build_answers(params)
        @parent = options[:parent]
        @errors = ActiveModel::Errors.new(self)
      end

      def find_question_by_name(name)
        match1 = subsections.find { |subsection| subsection.find_question_by_name(name) }
        match2 = find_first_match(answers, :find_by_name, name)
        match1 || match2
      end

      def add_multiple(name)
        question = find_question_by_name(name)
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
        [valid_subsections?, valid_answers?].inject(true) do |valid, valid_component|
          valid_component && valid
        end
      end

      def requires_dependencies?
        true
      end

      def reset
        subsections.each(&:reset)
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

      def valid_subsections?
        subsections.inject(true) do |valid, subsection|
          (subsection.valid? && valid).tap do
            subsection.errors.each do |attr, message|
              errors.add(attr, message)
            end
            subsection.errors.clear
          end
        end
      end

      def valid_answers?
        answers.inject(true) do |valid, answer|
          (answer.valid? && valid).tap do
            answer.errors.each do |attr, message|
              errors.add(attr, message)
            end
            answer.errors.clear
          end
        end
      end

      def build_subsections(params)
        section.subsections.map do |subsection|
          Forms::Assessments::Section.new(assessment, subsection, params, parent: self)
        end
      end

      def build_answers(params)
        section.questions.map do |question|
          Forms::Assessments::Answer.new(assessment, question, params, parent: self)
        end
      end
    end
  end
end
