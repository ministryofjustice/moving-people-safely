module Assessments
  class Question < SimpleDelegator
    attr_reader :schema, :parent, :subquestions, :dependency_questions

    delegate :name, :type, :group?, :string?, :boolean?, :complex?, to: :schema

    def initialize(object, schema, options = {})
      @schema = schema
      @parent = options[:parent]
      super(object)
      @subquestions = initialize_subquestions
      @dependency_questions = initialize_dependency_questions
    end

    def value
      public_send(name)
    end

    def relevant_answer?
      return false unless answered?
      schema.answers.any? ? answer_schema&.relevant? : true
    end

    def has_dependencies?
      answer_schema&.has_dependencies?
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

    def answer_requires_group_questions?
      schema.answers.find(&:has_group_questions?).present?
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

    def initialize_subquestions
      schema.subquestions.map do |question_schema|
        self.class.new(model, question_schema, parent: self)
      end
    end

    def initialize_dependency_questions
      schema.answers.flat_map(&:questions).flat_map do |question_schema|
        if question_schema.group?
          group = self.class.new(model, question_schema, parent: self)
          question_schema.subquestions.map do |subquestion_schema|
            self.class.new(model, subquestion_schema, parent: group)
          end
        else
          self.class.new(model, question_schema, parent: self)
        end
      end
    end

    def model
      __getobj__
    end
  end
end
