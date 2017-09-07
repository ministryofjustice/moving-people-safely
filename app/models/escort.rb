class Escort < ApplicationRecord
  AlreadyIssuedError = Class.new(StandardError)
  AlreadyCancelledError = Class.new(StandardError)

  default_scope { order('escorts.created_at desc') }
  default_scope { where(deleted_at: nil) }
  has_one :detainee, dependent: :destroy
  has_one :move, dependent: :destroy
  has_one :risk, dependent: :destroy
  has_one :healthcare, dependent: :destroy
  has_one :clone, class_name: 'Escort', foreign_key: :cloned_id
  belongs_to :twig, class_name: 'Escort', foreign_key: :cloned_id
  belongs_to :canceller, class_name: 'User'

  has_attached_file :document
  validates_attachment_content_type :document, content_type: ['application/pdf']

  scope :for_date, ->(date) { eager_load(:move).where(moves: { date: date }) }
  scope :for_user, lambda { |user|
    joins(:move).where('moves.from_establishment_id IN (?)', user.authorized_establishments) unless user.is_admin?
  }
  scope :with_incomplete_risk, -> { joins(:risk).merge(Risk.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(:healthcare).merge(Healthcare.not_confirmed) }
  scope :without_risk_assessment, -> { includes(:risk).where(risks: { escort_id: nil }) }
  scope :without_healthcare_assessment, -> { includes(:healthcare).where(healthcare: { escort_id: nil }) }
  scope :with_incomplete_offences, -> { joins(detainee: [:offences_workflow]).merge(OffencesWorkflow.not_confirmed) }
  scope :active, -> { where(issued_at: nil) }
  scope :uncancelled, -> { where(cancelled_at: nil) }
  scope :issued, -> { where.not(issued_at: nil) }
  scope :in_last_days, lambda { |num_days|
    joins(:move).where('moves.date >= ? AND moves.date < ?', num_days.days.ago.to_date, Date.current)
  }

  delegate :offences, :offences=, to: :detainee, allow_nil: true
  delegate :surname, :forenames, to: :detainee, prefix: true
  delegate :full_name, to: :canceller, prefix: true
  delegate :date, to: :move, prefix: true

  def current_establishment
    @current_establishment ||= Establishment.current_for(prison_number)
  end

  def completed?
    EscortCompletionValidator.call(self)
  end

  def cancelled?
    cancelled_at.present?
  end

  def editable?
    !(issued? || cancelled?)
  end

  def cancel!(user, reason)
    raise AlreadyCancelledError if cancelled?
    raise AlreadyIssuedError if issued?
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

  def document_path
    document.options[:storage] == :filesystem ? document.path : document.expiring_url
  end
end
