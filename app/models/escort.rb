class Escort < ApplicationRecord
  AlreadyIssuedError = Class.new(StandardError)

  default_scope { order('escorts.created_at desc') }
  default_scope { where(deleted_at: nil) }
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :clone, class_name: 'Escort', foreign_key: :cloned_id
  belongs_to :twig, class_name: 'Escort', foreign_key: :cloned_id

  scope :for_date, ->(date) { eager_load(:move).where(moves: { date: date }) }
  scope :with_incomplete_risk, -> { joins(:risk).merge(Risk.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(:healthcare).merge(Healthcare.not_confirmed) }
  scope :without_risk_assessment, -> { includes(:risk).where(risks: { escort_id: nil }) }
  scope :without_healthcare_assessment, -> { includes(:healthcare).where(healthcare: { escort_id: nil }) }
  scope :with_incomplete_offences, -> { joins(detainee: [:offences_workflow]).merge(OffencesWorkflow.not_confirmed) }
  scope :active, -> { where(issued_at: nil) }

  delegate :offences, :offences=, to: :detainee, allow_nil: true

  def current_establishment
    @current_establishment ||= Establishment.current_for(prison_number)
  end

  def completed?
    EscortCompletionValidator.call(self)
  end

  def issued?
    issued_at.present?
  end

  def issue!
    raise AlreadyIssuedError if issued?
    update_attribute(:issued_at, Time.now.utc)
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
