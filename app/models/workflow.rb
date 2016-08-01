class Workflow < ApplicationRecord
  belongs_to :move

  self.inheritance_column = :_type_disabled

  WORKFLOW_STATES = {
    not_started: 0,
    incomplete: 1,
    needs_review: 2,
    unconfirmed: 3,
    confirmed: 4,
    issued: 5
  }

  enum status: WORKFLOW_STATES

  scope :healthcare, -> { where type: 'healthcare' }
  scope :risk, -> { where type: 'risk' }
  scope :offences, -> { where type: 'offences' }
  scope :move, -> { where type: 'move' }

  scope :not_confirmed, -> { where.not(status: :confirmed) }
  scope :not_issued, -> { where.not(status: :issued) }
end
