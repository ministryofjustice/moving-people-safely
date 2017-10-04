module Schemas
  class Section
    attr_reader :name, :questions

    def initialize(name, hash)
      @name = name
      @hash = hash.with_indifferent_access
      initialize_questions_schema
    end

    private

    attr_reader :hash

    def initialize_questions_schema
      @questions = (hash['questions'] || []).map do |data|
        Schemas::Question.new(data)
      end
    end
  end
end
