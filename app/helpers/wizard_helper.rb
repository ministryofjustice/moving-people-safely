module WizardHelper
  def wizard_action
    %w[new create].include?(action_name) ? 'new' : 'edit'
  end
end
