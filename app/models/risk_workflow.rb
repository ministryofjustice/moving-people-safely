class RiskWorkflow < Workflow
  def self.sections
    %i[risk_to_self risk_from_others violence hostage_taker harassments
       sex_offences non_association_markers security substance_misuse
       concealed_weapons arson communication]
  end

  def self.mandatory_questions
    sections.map { |section_name| RiskAssessment.section_for(section_name).mandatory_questions }.flatten
  end
end
