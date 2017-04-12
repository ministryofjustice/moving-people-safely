class Escort < ApplicationRecord
  default_scope { order('escorts.created_at desc') }
  has_one :detainee
  has_one :move

  scope :for_date, ->(date) { eager_load(move: [:move_workflow]).where(moves: { date: date }) }
  scope :with_incomplete_risk, -> { joins(move: [:risk_workflow]).merge(Workflow.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(move: [:healthcare_workflow]).merge(Workflow.not_confirmed) }
  scope :with_incomplete_offences, -> { joins(move: [:offences_workflow]).merge(Workflow.not_confirmed) }

  delegate :risk_complete?, :healthcare_complete?, :offences_complete?, to: :move, allow_nil: true

  def risk
    detainee&.risk
  end

  def healthcare
    detainee&.healthcare
  end

  def offences
    detainee&.offences
  end

  def completed?
    EscortCompletionValidator.call(self)
  end

  def issued?
    move&.issued?
  end

  def issue!
    move.issued!
  end

  def needs_review!
    move.save_copy
  end

  def needs_review?
    risk.needs_review? ||
      healthcare.needs_review? ||
      offences.needs_review?
  end
end
