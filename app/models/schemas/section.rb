module Schemas
  class Section
    attr_reader :name, :subsections, :questions

    def initialize(name, hash)
      @name = name
      @hash = hash.with_indifferent_access
      initialize_subsections_schema
      initialize_questions_schema
    end

    def has_subsections?
      subsections.present?
    end

    private

    attr_reader :hash

    def initialize_subsections_schema
      @subsections = (hash['sections'] || []).map do |name, data|
        self.class.new(name, data)
      end
    end

    def initialize_questions_schema
      @questions = (hash['questions'] || []).map do |data|
        Schemas::Question.new(data)
      end
    end
  end
end
