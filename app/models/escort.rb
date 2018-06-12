class Escort < ApplicationRecord
  AlreadyIssuedError = Class.new(StandardError)
  AlreadyCancelledError = Class.new(StandardError)

  default_scope { order('escorts.cancelled_at desc, escorts.created_at desc') }
  default_scope { where(deleted_at: nil) }

  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_many :offences, dependent: :destroy
  has_one :offences_workflow, dependent: :destroy
  has_one :clone, class_name: 'Escort', foreign_key: :cloned_id

  belongs_to :twig, class_name: 'Escort', foreign_key: :cloned_id
  belongs_to :from_establishment, class_name: 'Establishment'
  belongs_to :canceller, class_name: 'User'

  has_attached_file :document
  validates_attachment_content_type :document, content_type: ['application/pdf']

  scope :for_date, ->(date) { where(date: date) }
  scope :for_establishment, lambda { |establishment|
    where(from_establishment: establishment) if establishment
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
    where('date >= ? AND date < ?', num_days.days.ago.to_date, Date.current)
  }
  scope :in_month, lambda { |month, year|
    where('extract(month from date) = ? AND extract(year from date) = ? ', month, year)
  }
  scope :in_court, ->(court_name) { where(to: court_name) if court_name }
  scope :for_today, -> { where(date: Date.current) }
  scope :from_prison, -> { includes(:from_establishment).where(establishments: { type: 'Prison' }) }
  scope :from_police, -> { includes(:from_establishment).where(establishments: { type: 'PoliceCustody' }) }

  delegate :full_name, to: :canceller, prefix: true

  def completed?
    EscortCompletionValidator.call(self)
  end

  def expired?
    date < Date.current
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

  def alerts
    move_alerts = { not_for_release: (not_for_release == 'yes') }
    move_alerts.merge(risk&.alerts || {})
  end

  def active_alerts
    alerts.select { |_k, v| v == true }.keys
  end

  def from_prison?
    from_establishment&.type == 'Prison'
  end

  def from_police?
    from_establishment&.type == 'PoliceCustody'
  end

  def number
    return pnc_number if from_police?
    prison_number
  end
end
