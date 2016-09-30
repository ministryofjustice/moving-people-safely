class Move < ApplicationRecord
  belongs_to :detainee
  has_many :destinations, dependent: :destroy

  has_one :healthcare_workflow, -> { Workflow.healthcare }, class_name: 'Workflow'
  has_one :risk_workflow, -> { Workflow.risk }, class_name: 'Workflow'
  has_one :offences_workflow, -> { Workflow.offences }, class_name: 'Workflow'
  has_one :workflow, -> { Workflow.move }, class_name: 'Workflow'

  scope :for_date, (lambda do |search_date|
    where(date: search_date).
      order(created_at: :desc).
      eager_load(
        :detainee,
        :workflow)
  end)

  scope :active, -> { joins(:workflow).merge(Workflow.not_issued) }

  scope :with_incomplete_risk, -> { joins(:risk_workflow).merge(Workflow.not_confirmed) }
  scope :with_incomplete_healthcare, -> { joins(:healthcare_workflow).merge(Workflow.not_confirmed) }
  scope :with_incomplete_offences, -> { joins(:offences_workflow).merge(Workflow.not_confirmed) }

  scope :order_by_recentness, -> { order(created_at: :desc) }

  # this should be in some kind of form, lol

  REASONS = %w[
    discharge_to_court
    production_to_court
    police_production
    other
  ]

  validates :reason, inclusion: { in: REASONS }, allow_blank: true
  validates :reason_details, presence: true, if: -> { reason == 'other' }
  validate :validate_date

  def validate_date
    if date.is_a? Date
      errors[:date] << 'must not be in the past.' if date < Date.today
    else
      errors.add(:date)
    end
  end

  def reasons
    REASONS
  end

  ####

  def initialize(*)
    super
    build_workflow
    build_risk_workflow
    build_healthcare_workflow
    build_offences_workflow
  end

  def copy_without_saving
    dup.tap do |move|
      move.date = nil
    end
  end

  def save_copy
    transaction do
      create_workflow
      create_risk_workflow.needs_review!
      create_healthcare_workflow.needs_review!
      create_offences_workflow.needs_review!
    end
    save
  end

  def complete?
    risk_complete? &&
      healthcare_complete? &&
      offences_complete?
  end

  def risk_complete?
    risk_workflow.confirmed?
  end

  def healthcare_complete?
    healthcare_workflow.confirmed?
  end

  def offences_complete?
    offences_workflow.confirmed?
  end
end
