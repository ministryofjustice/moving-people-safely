module Forms
  class Assessment
    def self.for_section(assessment, section_name, params = {})
      section = assessment.schema.for_section(section_name)
      return unless section
      Forms::Assessments::Section.new(assessment, section, params)
    end
  end
end
