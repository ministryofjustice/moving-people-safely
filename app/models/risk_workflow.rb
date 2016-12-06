class RiskWorkflow < Workflow
  def self.steps
    %i[risk_to_self risk_from_others violence harassments
       sex_offences non_association_markers security substance_misuse
       concealed_weapons arson communication]
  end
end
