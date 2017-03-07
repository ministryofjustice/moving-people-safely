module HealthcareAssessment
  def section_for(section_name)
    "HealthcareAssessment::#{section_name.to_s.camelcase}Section".constantize.new
  end

  def sections
    @sections ||= ASSESSMENTS_SCHEMA['healthcare']['sections'].map do |name, data|
      Assessments::Section.new(name, data)
    end
  end

  module_function :section_for, :sections
end
