class DocumentWorkflow
  class WorkflowStateChangeError < RuntimeError; end
  class InvalidWorkflowStateError < StandardError; end

  def initialize(model)
    @model = model
  end

  def update_status(new_status)
    check_status!(new_status)

    if can_transition_to?(new_status)
      model.workflow_status = new_status
    else
      false
    end
  end

  def can_update_status?(new_status)
    can_transition_to?(new_status)
  end

  def update_status!(new_status)
    unless update_status(new_status)
      fail WorkflowStateChangeError, "Cannot change to #{new_status}"
    end
  end

  private

  attr_reader :model

  def check_status!(new_status)
    unless %i[ not_started incomplete needs_review complete ].include? new_status
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

  def can_transition_to_complete?
    model.all_questions_answered?
  end
end
