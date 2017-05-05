module Forms
  module Assessments
    class Section < SimpleDelegator
      attr_reader :parent

      def initialize(assessment, section, params, options = {})
        super(assessment)
        @assessment = assessment
        @section = section
        @params = params
        @subsections = build_subsections(params)
        @answers = build_answers(params)
        @parent = options[:parent]
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

      attr_reader :assessment, :section, :answers, :subsections

      def valid_subsections?
        subsections.inject(true) do |valid, subsection|
          subsection.valid? && valid
        end
      end

      def valid_answers?
        answers.inject(true) do |valid, answer|
          (answer.valid? && valid).tap do
            answer.errors.each do |attr, message|
              errors.add(attr, message)
            end
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
