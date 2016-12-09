class HealthcareWorkflow < Workflow
  def self.sections
    %i[physical mental social allergies needs transport contact]
  end
end
