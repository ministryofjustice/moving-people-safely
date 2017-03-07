module Assessments
  class Section
    attr_reader :name, :questions, :subsections

    def initialize(name, data = {})
      @name = name
      @data = data.deep_symbolize_keys
      @questions = initialize_questions(@data)
      @subsections = initialize_subsections(@data)
    end

    def has_subsections?
      subsections.present?
    end

    private

    def initialize_questions(data)
      data.fetch(:questions, []).map do |question_data|
        Question.new(question_data.merge(section: self))
      end
    end

    def initialize_subsections(data)
      data.fetch(:subsections, []).map do |subsection_name, subsection_data|
        self.class.new(subsection_name, subsection_data)
      end
    end
  end
end
