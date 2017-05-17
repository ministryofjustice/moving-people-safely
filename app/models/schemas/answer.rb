module Schemas
  class Answer
    attr_reader :value, :relevant, :questions

    def initialize(hash)
      @hash = hash.with_indifferent_access
      @value = @hash.fetch('value')
      @relevant = @hash.fetch('relevant', false)
      @questions = initialize_questions_schema
    end

    def group_questions
      return [] unless group
      group.subquestions
    end

    def group
      questions.find(&:group?)
    end

    def has_group_questions?
      group_questions.present?
    end

    def has_dependencies?
      questions.present?
    end

    def relevant?
      relevant || value == 'yes' || value == true
    end

    private

    attr_reader :hash

    def initialize_questions_schema
      (hash['questions'] || []).map do |data|
        Schemas::Question.new(data)
      end
    end
  end
end
