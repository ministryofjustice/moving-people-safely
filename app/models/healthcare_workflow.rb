class HealthcareWorkflow < Workflow
  def self.sections
    %i[physical mental social allergies needs transport communication contact]
  end

  def self.sections_for_summary
    %i[physical mental social allergies needs transport communication]
  end

  def self.mandatory_questions
    sections_for_summary.map do |section_name|
      HealthcareAssessment.section_for(section_name).mandatory_questions
    end.flatten
  end
end
