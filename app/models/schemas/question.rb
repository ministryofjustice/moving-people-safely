module Schemas
  class Question
    attr_reader :name, :type, :subquestions, :validators, :answers

    def initialize(hash)
      @hash = hash.with_indifferent_access
      @name = @hash.fetch('name')
      @type = @hash.fetch('type')
      @subquestions = initialize_subquestions_schema
      @answers = initialize_answers_schema
      @validators = initialize_validators_schema
    end

    def has_dependencies?
      answers.flat_map(&:questions).any?
    end

    def answer_for(value)
      answers.find { |answer| answer.value == value }
    end

    def answer_options
      answers.map(&:value)
    end

    def group?
      type == 'group'
    end

    def complex?
      type == 'complex'
    end

    def string?
      type == 'string'
    end

    def boolean?
      type == 'boolean'
    end

    private

    attr_reader :hash

    def initialize_subquestions_schema
      (hash['questions'] || []).map do |data|
        Schemas::Question.new(data)
      end
    end

    def initialize_validators_schema
      (hash['validators'] || []).map do |data|
        Schemas::Validator.new(data)
      end
    end

    def initialize_answers_schema
      (hash['answers'] || []).map do |data|
        Schemas::Answer.new(data)
      end
    end
  end
end
