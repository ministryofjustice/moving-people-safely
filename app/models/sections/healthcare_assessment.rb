module HealthcareAssessment
  def section_for(section_name)
    "HealthcareAssessment::#{section_name.to_s.camelcase}Section".constantize.new
  end

  module_function :section_for
end
