class RiskWorkflow < Workflow
  def self.mandatory_questions
    sections.map { |section_name| RiskAssessment.section_for(section_name).mandatory_questions }.flatten
  end
end
