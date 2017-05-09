module Assessments
  class Section < SimpleDelegator
    attr_reader :schema, :parent, :subsections, :questions

    delegate :name, :has_subsections?, to: :schema

    def initialize(object, schema, options = {})
      @schema = schema
      @parent = options[:parent]
      super(object)
      initialize_subsections
      initialize_questions
    end

    def is_section?
      true
    end

    def is_question?
      false
    end

    def mandatory_questions
      questions + subsections.flat_map(&:questions)
    end

    private

    def initialize_subsections
      @subsections = schema.subsections.map do |subsection_schema|
        self.class.new(model, subsection_schema, parent: self)
      end
    end

    def initialize_questions
      @questions = schema.questions.map do |question_schema|
        Assessments::Question.new(model, question_schema, parent: self)
      end
    end

    def model
      __getobj__
    end
  end
end
