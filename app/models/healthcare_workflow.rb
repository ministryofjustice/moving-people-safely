class HealthcareWorkflow < Workflow
  def self.sections
    %w[physical mental social allergies needs transport communication contact]
  end

  def self.mandatory_questions
    sections.map do |section_name|
      HealthcareAssessment.section_for(section_name).mandatory_questions
    end.flatten
  end
end
