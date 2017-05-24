class Escort < ApplicationRecord
  default_scope { order('escorts.created_at desc') }
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy

  default_scope { where(deleted_at: nil) }

  scope :for_date, ->(date) { eager_load(move: [:move_workflow]).where(moves: { date: date }) }
  scope :with_incomplete_risk, -> { joins(:risk).merge(Risk.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(:healthcare).merge(Healthcare.not_confirmed) }
  scope :without_risk_assessment, -> { includes(:risk).where(risks: { escort_id: nil }) }
  scope :without_healthcare_assessment, -> { includes(:healthcare).where(healthcare: { escort_id: nil }) }
  scope :with_incomplete_offences, -> { joins(detainee: [:offences_workflow]).merge(Workflow.not_confirmed) }
  scope :active, -> { joins(:move).merge(Move.active) }

  delegate :offences, :offences=, to: :detainee, allow_nil: true

  def current_establishment
    @current_establishment ||= Establishment.current_for(prison_number)
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
    transaction do
      risk&.needs_review!
      healthcare&.needs_review!
      offences&.needs_review!
    end
  end

  def needs_review?
    risk.needs_review? ||
      healthcare.needs_review? ||
      offences.needs_review?
  end

  def risk_complete?
    risk&.confirmed?
  end

  def healthcare_complete?
    healthcare&.confirmed?
  end

  def offences_complete?
    offences&.confirmed?
  end
end
