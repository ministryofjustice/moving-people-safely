class Escort < ApplicationRecord
  AlreadyIssuedError = Class.new(StandardError)
  AlreadyCancelledError = Class.new(StandardError)

  default_scope { order('escorts.created_at desc') }
  default_scope { where(deleted_at: nil) }
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :offences_workflow, dependent: :destroy
  has_one :clone, class_name: 'Escort', foreign_key: :cloned_id
  belongs_to :twig, class_name: 'Escort', foreign_key: :cloned_id
  belongs_to :canceller, class_name: 'User'

  has_attached_file :document
  validates_attachment_content_type :document, content_type: ['application/pdf']

  scope :for_date, ->(date) { eager_load(:move).where(moves: { date: date }) }
  scope :for_user, lambda { |user|
    joins(:move).where('moves.from_establishment_id IN (?)', user.authorized_establishments) unless user.admin?
  }
  scope :with_unconfirmed_risk, -> { joins(:risk).merge(Risk.not_confirmed) }
  scope :with_unconfirmed_healthcare, -> { joins(:healthcare).merge(Healthcare.not_confirmed) }
  scope :with_unconfirmed_offences, -> { joins(:offences_workflow).merge(OffencesWorkflow.not_confirmed) }
  scope :without_risk_assessment, -> { includes(:risk).where(risks: { escort_id: nil }) }
  scope :without_healthcare_assessment, -> { includes(:healthcare).where(healthcare: { escort_id: nil }) }
  scope :without_offences_workflow, -> { includes(:offences_workflow).where(offences_workflows: { escort_id: nil }) }
  scope :active, -> { where(issued_at: nil) }
  scope :uncancelled, -> { where(cancelled_at: nil) }
  scope :issued, -> { where.not(issued_at: nil) }
  scope :in_last_days, lambda { |num_days|
    joins(:move).where('moves.date >= ? AND moves.date < ?', num_days.days.ago.to_date, Date.current)
  }
  scope :in_court, ->(court_name) { joins(:move).where('moves.to = ?', court_name) if court_name }
  scope :for_today, -> { joins(:move).where('moves.date = ?', Date.current) }

  delegate :offences, :offences=, to: :detainee, allow_nil: true
  delegate :surname, :forenames, to: :detainee, prefix: true
  delegate :full_name, to: :canceller, prefix: true
  delegate :date, :from_establishment, to: :move, prefix: true

  def completed?
    EscortCompletionValidator.call(self)
  end

  def editable?
    !(issued? || cancelled?)
  end

  def cancelled?
    cancelled_at.present?
  end

  def cancel!(user, reason)
    raise AlreadyCancelledError if cancelled?
    update_attributes!(canceller_id: user.id, cancelling_reason: reason, cancelled_at: Time.now.utc)
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
      offences_workflow&.needs_review!
    end
  end

  def needs_review?
    risk.needs_review? ||
      healthcare.needs_review? ||
      offences_workflow.needs_review?
  end

  def risk_complete?
    risk&.confirmed?
  end

  def healthcare_complete?
    healthcare&.confirmed?
  end

  def offences_complete?
    offences_workflow&.confirmed?
  end

  def document_path
    document.options[:storage] == :filesystem ? document.path : document.expiring_url
  end

  def active_alerts
    move.active_alerts + risk.active_alerts
  end
end
