module RiskAssessment
  def section_for(section_name)
    "RiskAssessment::#{section_name.to_s.camelcase}Section".constantize.new
  end

  def sections
    @sections ||= ASSESSMENTS_SCHEMA['risk']['sections'].map do |name, data|
      Assessments::Section.new(name, data)
    end
  end

  module_function :section_for, :sections
end
