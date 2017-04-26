module Schemas
  class Assessment
    attr_reader :sections, :questions

    def initialize(hash)
      @hash = hash.with_indifferent_access
      initialize_sections_schema
      initialize_questions_schema
    end

    def for_section(section_name)
      sections.find { |section| section.name.to_s == section_name.to_s }
    end

    private

    attr_reader :hash

    def initialize_sections_schema
      @sections = (hash['sections'] || []).map do |name, data|
        Schemas::Section.new(name, data)
      end
    end

    def initialize_questions_schema
      @questions = (hash['questions'] || []).map do |data|
        Schemas::Question.new(data)
      end
    end
  end
end
