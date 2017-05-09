module Assessments
  class Question < SimpleDelegator
    attr_reader :schema, :parent, :group_questions

    delegate :name, :group?, :string?, :complex?, to: :schema

    def initialize(object, schema, options = {})
      @schema = schema
      @parent = options[:parent]
      super(object)
      @group_questions = initialize_group_questions
    end

    def value
      public_send(name)
    end

    def relevant_answer?
      answer_schema&.relevant?
    end

    def has_dependencies?
      answer_schema&.has_dependencies?
    end

    def dependency_questions
      answer_schema&.questions
    end

    def answered?
      return false if value.nil? || value == 'unknown'
      value.present?
    end

    def is_section?
      false
    end

    def is_question?
      true
    end

    def belongs_to_group?
      return unless parent
      parent.is_question? && parent.group?
    end

    def parent_group_answer
      parent&.parent&.value if belongs_to_group?
    end

    def section_name
      return unless parent
      return parent.name if parent.is_section?
      parent.section_name
    end

    def answer_schema
      schema.answer_for(value)
    end

    def to_ary
      [self]
    end

    private

    def initialize_group_questions
      group_schema = schema.answers.find(&:has_group_questions?)&.group
      return [] unless group_schema
      group = self.class.new(model, group_schema, parent: self)
      group_schema.subquestions.map do |question_schema|
        self.class.new(model, question_schema, parent: group)
      end
    end

    def model
      __getobj__
    end
  end
end
