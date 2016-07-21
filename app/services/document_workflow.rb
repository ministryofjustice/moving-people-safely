class DocumentWorkflow
  class InvalidWorkflowStateError < StandardError; end
  class StateChangeError < RuntimeError; end

  WORKFLOW_STATES = %i[ not_started incomplete needs_review complete issued ]

  WORKFLOW_STATES.each do |state|
    define_method("is_#{state}?") { model.workflow_status == state.to_s }
  end

  def initialize(model)
    @model = model
  end

  def update_status(new_status)
    validate_status!(new_status)

    if can_transition_to?(new_status)
      model.update_attribute(:workflow_status, new_status)
      new_status
    else
      false
    end
  end

  def update_status!(new_status)
    fail StateChangeError unless update_status(new_status)
    new_status
  end

  private

  attr_reader :model

  def validate_status!(new_status)
    unless WORKFLOW_STATES.include? new_status
      fail InvalidWorkflowStateError, "#{new_status} is not a valid workflow state."
    end
  end

  def can_transition_to?(new_status)
    checker_method = "can_transition_to_#{new_status}?"
    if respond_to?(checker_method, true)
      send checker_method
    else
      true
    end
  end

  def can_transition_to_issued?
    model.is_a?(Escort) && model.move.complete?
  end

  def can_transition_to_complete?
    model.all_questions_answered?
  end
end
