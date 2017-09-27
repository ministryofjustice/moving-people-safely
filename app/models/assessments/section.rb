module Assessments
  class Section < SimpleDelegator
    attr_reader :schema, :parent, :questions

    delegate :name, to: :schema

    def initialize(object, schema, options = {})
      @schema = schema
      @parent = options[:parent]
      super(object)
      initialize_questions
    end

    def is_section?
      true
    end

    def is_question?
      false
    end

    def mandatory_questions
      questions
    end

    private

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
