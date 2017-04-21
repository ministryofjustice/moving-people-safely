module Schemas
  class Question
    attr_reader :name, :type, :subquestions, :answers

    def initialize(hash)
      @hash = hash.with_indifferent_access
      @name = @hash.fetch('name')
      @type = @hash.fetch('type')
      initialize_subquestions_schema
      initialize_answers_schema
    end

    def has_dependencies?
      answers.flat_map(&:questions).any?
    end

    private

    attr_reader :hash

    def initialize_subquestions_schema
      @subquestions = (hash['questions'] || []).map do |data|
        Schemas::Question.new(data)
      end
    end

    def initialize_answers_schema
      @answers = (hash['answers'] || []).map do |data|
        Schemas::Answer.new(data)
      end
    end
  end
end
