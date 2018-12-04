# frozen_string_literal: true

module WizardHelper
  def wizard_action
    %w[new create].include?(action_name) ? 'new' : 'edit'
  end

  def assessment_wizard_path(assessment)
    action = assessment.present? ? :edit : :new
    wizard_path(step, action: action)
  end
end
