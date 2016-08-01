class Workflow < ApplicationRecord
  belongs_to :move

  WORKFLOW_STATES = {
    not_started: 0,
    incomplete: 1,
    needs_review: 2,
    unconfirmed: 3,
    confirmed: 4,
    issued: 5
  }

  enum status: WORKFLOW_STATES
end
