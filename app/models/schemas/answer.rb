module Schemas
  class Answer
    attr_reader :value, :questions

    def initialize(hash)
      @hash = hash.with_indifferent_access
      @value = @hash.fetch('value')
      @questions = initialize_questions_schema
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
